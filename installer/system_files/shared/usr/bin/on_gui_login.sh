#!/usr/bin/bash
# Project Orbis – Hinweise und Willkommensdialog beim Anmelden in der Live-Sitzung.
#
# Abgeleitet von ublue-os/bazzite installer/system_files/shared/usr/bin/on_gui_login.sh
# (Apache-2.0), Stand Commit 5d71c4376169910c25bc06a3537f4780521e7435, siehe NOTICE.
# ORBIS-Änderungen:
#   - Name aus /usr/share/orbis/branding.env statt fest "Bazzite"
#   - Texte Englisch und Deutsch (statt Schwedisch)
#   - ohne NVIDIA-Hilfsdialog (an Bazzite-Image-Namen gebunden; Orbis-NVIDIA-Variante folgt später)
#   - ohne Knopf für das Bazzite-Werkzeug zur Bootloader-Wiederherstellung
#     (Bootloader-Eingriffe nur mit ausdrücklicher Zustimmung, siehe CLAUDE.md)

conky -c /usr/share/conky/conky.conf &

OS_NAME="Orbis"
if [[ -r /usr/share/orbis/branding.env ]]; then
    # shellcheck disable=SC1091
    source /usr/share/orbis/branding.env
    OS_NAME="${ORBIS_OS_NAME:-$OS_NAME}"
fi

is_german_locale() {
    [[ "${LC_MESSAGES:-${LANG:-C}}" == de* ]]
}

# Ohne UEFI (CSM/Legacy) ist keine Installation möglich: Hinweis und Ausschalten
if [[ ! -d /sys/firmware/efi ]]; then
    if is_german_locale; then
        legacy_boot_message="${OS_NAME} unterstützt keinen CSM/Legacy-Start. Bitte im UEFI/BIOS den CSM/Legacy-Modus ausschalten und neu starten."
        shutdown_button="Ausschalten"
    else
        legacy_boot_message="${OS_NAME} does not support CSM/Legacy Boot. Please boot into your UEFI/BIOS settings, disable CSM/Legacy Mode, and reboot."
        shutdown_button="Shutdown"
    fi
    yad --undecorated --on-top --timeout=0 --button="$shutdown_button:0" \
        --text="$legacy_boot_message" || true
    systemctl poweroff || shutdown -h now || true
fi

# Mit weniger als etwa 5 GB Arbeitsspeicher schlägt die Installation fast sicher fehl
block_low_memory_install() {
    memory=$(grep 'MemTotal' /proc/meminfo | cut -d ":" -f 2 | cut -d "k" -f 1 | sed 's/ //g')
    gb_memory=$(
        awk '/^MemTotal/{print $2*1024}' </proc/meminfo |
            numfmt --to=iec --format=%0f --suffix=B
    )
    if [[ -z $memory || $memory -eq 0 ]]; then
        echo "could not determine memory. Exiting."
        return 1
    elif [[ $memory -ge 5000000 ]]; then
        return 0
    fi
    echo "detected memory less than approx. 5GB, warning user"
    if is_german_locale; then
        text="Für die Installation von ${OS_NAME} braucht es <b>mindestens 8 GB Arbeitsspeicher</b>.\n\nMit 4 GB oder weniger schlägt die Installation sehr wahrscheinlich fehl.\n\nErkannter Arbeitsspeicher: $gb_memory\n\nIn einer virtuellen Maschine: festen Arbeitsspeicher von mindestens 8 GB einstellen."
        title="Zu wenig Arbeitsspeicher"
        shutdown_button="Ausschalten"
    else
        text="You need <b>at least 8GB of system memory</b> to install ${OS_NAME}.\n\nInstallation with 4GB or less memory will likely fail.\n\nDetected amount of memory: $gb_memory\n\nIn a virtual machine: assign at least 8GB of fixed memory."
        title="Not enough memory"
        shutdown_button="Shutdown"
    fi
    while true; do
        yad --undecorated --on-top --timeout=0 --button="$shutdown_button:0" --warning \
            --buttons-layout=center --text-align=center --title="$title" --text="$text"
        case $? in
        0)
            systemctl poweroff || shutdown -h now || true
            break
            ;;
        esac
    done
}

welcome_dialog() {
    _EXITLOCK=1
    _RETVAL=0
    local welcome_text="
Welcome to the ${OS_NAME} Live ISO!

The Live ISO is designed for installation and troubleshooting.
It does <b>not</b> have all drivers and is <b>not capable of playing games.</b>

Please <b>do not use it in benchmarks</b> as it
does not represent the installed experience."
    local welcome_title="Welcome"
    local install_button="Install ${OS_NAME}"
    local close_button="Close dialog"
    if is_german_locale; then
        welcome_text="
Willkommen in der Live-ISO von ${OS_NAME}!

Die Live-ISO dient zum Installieren und zur Fehlersuche.
Sie hat <b>nicht</b> alle Treiber und ist <b>nicht zum Spielen gedacht.</b>

Bitte <b>keine Leistungsmessungen</b> damit machen,
sie entspricht nicht dem installierten System."
        welcome_title="Willkommen"
        install_button="${OS_NAME} installieren"
        close_button="Dialog schliessen"
    fi
    while [[ $_EXITLOCK -eq 1 ]]; do
        yad \
            --no-escape \
            --on-top \
            --timeout-indicator=bottom \
            --text-align=center \
            --buttons-layout=center \
            --title="$welcome_title" \
            --text="$welcome_text" \
            --button="$install_button:10" \
            --button="$close_button:0"
        _RETVAL=$?
        case $_RETVAL in
        10)
            liveinst &
            disown $!
            _EXITLOCK=0
            ;;
        0) _EXITLOCK=0 ;;
        esac
    done
    unset -v _EXITLOCK
    unset -v _RETVAL
}

block_low_memory_install

# Warnung, wenn auf einem Laufwerk schon ein anderer Linux-Bootloader liegt
# (Doppelstart mit einem anderen Linux wird nicht unterstützt). Nur lesen, nichts ändern.
efi="c12a7328-f81f-11d2-ba4b-00a0c93ec93b"
declare -A mount
while read -r device path; do
    mount["$device"]="-o bind,ro $path"
done < <(lsblk -o PATH,MOUNTPOINTS -nQ 'PARTTYPE=="'$efi'" && MOUNTPOINTS' 2>/dev/null || true)

for device in $(lsblk -o PATH -nQ 'PARTTYPE=="'$efi'" && !MOUNTPOINTS' 2>/dev/null || true); do
    mount["$device"]="-o ro -t vfat $device"
done

mnt=$(mktemp -d)
export mnt
trap "rmdir '$mnt'" EXIT

for device in "${!mount[@]}"; do
    export device OS_NAME
    export ORBIS_INSTALLER_LOCALE="${LC_MESSAGES:-${LANG:-C}}"
    msg=$(sudo -E unshare -m sh -c '
        mount '"${mount[$device]} '$mnt'"' 2> /dev/null || exit 0
        shopt -s nullglob nocaseglob
        for dir in "$mnt"/EFI/*; do
            [ -d "$dir" ] || continue
            base=$(basename "$dir" | tr "[:upper:]" "[:lower:]")
            [[ "$base" == "fedora" || "$base" == "boot" ]] && continue
            grub=("$dir"/grub*.efi)
            (( ! ${#grub[@]} )) && continue
            if [[ "$ORBIS_INSTALLER_LOCALE" == de* ]]; then
                echo "Auf $device liegt unter ${dir#$mnt} bereits ein anderer Linux-Bootloader.\n$OS_NAME unterstützt keinen Doppelstart mit einem anderen Linux.\nEine Installation auf dieses Laufwerk wird fehlschlagen.\nBitte $OS_NAME auf ein anderes Laufwerk installieren.\n"
            else
                echo "Another Linux bootloader seems to be installed on $device at ${dir#$mnt}.\n$OS_NAME does not support dualbooting with any other Linux.\nInstalling $OS_NAME to this drive will fail.\nPlease install $OS_NAME to a different disk.\n"
            fi
        done
    ' || true)
    [ "$msg" ] || continue
    if is_german_locale; then
        yad --image=dialog-warning --button=OK --buttons-layout=center --title="Anderer Linux-Bootloader gefunden" --text="$msg"
    else
        yad --image=dialog-warning --button=OK --buttons-layout=center --title="Existing Linux bootloader detected" --text="$msg"
    fi
done

echo 'launch welcome dialog'
welcome_dialog

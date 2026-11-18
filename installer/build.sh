#!/usr/bin/bash
# Project Orbis – richtet die Live-ISO-Umgebung ein (läuft beim Bauen von installer/Containerfile).
#
# Abgeleitet von ublue-os/bazzite installer/build.sh (Apache-2.0), Stand Commit
# 5d71c4376169910c25bc06a3537f4780521e7435, siehe NOTICE. Ursprünglich:
# https://github.com/ondrejbudai/bootc-isos/blob/3b3a185e4a57947f57baf53d2be5aee469274f98/bazzite/src/build.sh
#
# Orbis-Änderungen sind mit "ORBIS:" markiert:
#   - Repository-Wurzel als Kontext, Pfade unter /src/installer
#   - Name und ISO-Bezeichnung aus branding/branding.env statt fest "Bazzite"
#   - Installations-Image wird an die Hooks übergeben (statt Suche nach "bazzite*")
#   - nur KDE, kein GNOME

set -exo pipefail

{ export PS4='+( ${BASH_SOURCE}:${LINENO} ): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'; } 2>/dev/null

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_IMAGE=${BASE_IMAGE:?}
INSTALL_IMAGE_PAYLOAD=${INSTALL_IMAGE_PAYLOAD:?}
FLATPAK_DIR_SHORTNAME=${FLATPAK_DIR_SHORTNAME:?}

# ORBIS: Name und Marke nur aus branding.env; an die Hooks weitergeben
set -a
# shellcheck source=../branding/branding.env
source /src/branding/branding.env
set +a
: "${ORBIS_OS_NAME:?}"
export ORBIS_PAYLOAD_REF="${INSTALL_IMAGE_PAYLOAD}"
# Für Anzeige in der Live-Sitzung (Willkommensdialog, Conky)
mkdir -p /usr/share/orbis
echo "${INSTALL_IMAGE_PAYLOAD}" >/usr/share/orbis/installer-payload

# Create the directory that /root is symlinked to
mkdir -p "$(realpath /root)"

# bwrap tries to write /proc/sys/user/max_user_namespaces which is mounted as ro
# so we need to remount it as rw
mount -o remount,rw /proc/sys

# Install flatpaks
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
xargs -r flatpak install -y --noninteractive <"${SCRIPT_DIR}/${FLATPAK_DIR_SHORTNAME}/flatpaks"

# Pull the container image to be installed
if mountpoint -q /usr/lib/containers/storage; then
    # We load our image from the host container storage if possible
    podman save --format oci-archive "$INSTALL_IMAGE_PAYLOAD" | podman load --storage-opt additionalimagestore=''
else
    podman pull "$INSTALL_IMAGE_PAYLOAD"
fi

# Copy system files (ORBIS: nur KDE)
echo "Copying shared system files..."
cp -a "${SCRIPT_DIR}/system_files/shared/." /
echo "Copying KDE-specific system files..."
cp -a "${SCRIPT_DIR}/system_files/kde/." /

# Run the preinitramfs hook
"$SCRIPT_DIR/titanoboa_hook_preinitramfs.sh"

# Install dracut-live and regenerate the initramfs
dnf install -y dracut-live
kernel=$(kernel-install list --json pretty | jq -r '.[] | select(.has_kernel == true) | .version')
DRACUT_NO_XATTR=1 dracut -v --force --reproducible --no-hostonly \
    --add "dmsquash-live dmsquash-live-autooverlay" \
    "/usr/lib/modules/${kernel}/initramfs.img" "${kernel}"

# Install livesys-scripts and configure them (ORBIS: KDE)
dnf install -y livesys-scripts
sed -i "s/^livesys_session=.*/livesys_session=kde/" /etc/sysconfig/livesys
systemctl enable livesys.service livesys-late.service

# Run the postrootfs hook
"$SCRIPT_DIR/titanoboa_hook_postrootfs.sh"

# image-builder needs gcdx64.efi
dnf install -y grub2-efi-x64-cdboot

# image-builder expects the EFI directory to be in /boot/efi
mkdir -p /boot/efi
cp -av /usr/lib/efi/*/*/EFI /boot/efi/

# Remove fallback efi
cp -v /boot/efi/EFI/fedora/grubx64.efi /boot/efi/EFI/BOOT/fbx64.efi # NOTE: remove this line if breaks bootloader

# Set the timezone to UTC
rm -f /etc/localtime
systemd-firstboot --timezone UTC

# / in a booted live ISO is an overlayfs with upperdir pointed somewhere under /run
# This means that /var/tmp is also technically under /run.
# /run is of course a tmpfs, but set with quite a small size.
# ostree needs quite a lot of space on /var/tmp for temporary files so /run is not enough.
# Mount a larger tmpfs to /var/tmp at boot time to avoid this issue.
rm -rf /var/tmp
mkdir /var/tmp
cat >/etc/systemd/system/var-tmp.mount <<'EOF'
[Unit]
Description=Larger tmpfs for /var/tmp on live system

[Mount]
What=tmpfs
Where=/var/tmp
Type=tmpfs
Options=size=50%%,nr_inodes=1m,x-systemd.graceful-option=usrquota

[Install]
WantedBy=local-fs.target
EOF
systemctl enable var-tmp.mount

# Mount /var/lib/flatpak as readonly.
# This is in order to ensure the files dont get tainted when installing them in disk.
cat >/etc/systemd/system/var-lib-flatpak.mount <<'EOF'
[Mount]
Type=none
What=/var/lib/flatpak
Where=/var/lib/flatpak
Options=bind,ro

[Install]
WantedBy=multi-user.target
EOF
systemctl enable var-lib-flatpak.mount

# systemd-tmpfiles fails to label the install target when /mnt is a symlink
rm /mnt
mkdir /mnt

# ORBIS: ISO-Konfiguration aus branding.env erzeugen (statt fester iso.yaml mit "Bazzite").
# Die Bezeichnung muss mit root=live:CDLABEL=... übereinstimmen und darf keine Leerzeichen haben.
iso_label="${ORBIS_OS_NAME// /_}-Live"
mkdir -p /usr/lib/bootc-image-builder
cat >/usr/lib/bootc-image-builder/iso.yaml <<EOF
label: "${iso_label}"
grub2:
  timeout: 5
  entries:
    - name: "${ORBIS_OS_NAME} starten / installieren (Start / Install ${ORBIS_OS_NAME})"
      linux: "/images/pxeboot/vmlinuz quiet rhgb root=live:CDLABEL=${iso_label} enforcing=0 rd.live.image"
      initrd: "/images/pxeboot/initrd.img"
    - name: "${ORBIS_OS_NAME} - einfacher Grafikmodus (Basic Graphics Mode)"
      linux: "/images/pxeboot/vmlinuz quiet rhgb root=live:CDLABEL=${iso_label} enforcing=0 rd.live.image nomodeset"
      initrd: "/images/pxeboot/initrd.img"
EOF
cat /usr/lib/bootc-image-builder/iso.yaml

# Clean up dnf cache to save space
dnf clean all

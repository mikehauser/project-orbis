#!/bin/bash
# Project Orbis – Build-Skript für die eigene Image-Schicht.
# Wird von image/Containerfile aufgerufen. Status der enthaltenen Funktionen: implementiert, nicht getestet.

set -ouex pipefail

# ---------------------------------------------------------------
# 1. Eigene Dateien überlagern (image/system_files/ nach /)
# ---------------------------------------------------------------
cp -avf "/ctx/system_files"/. /

# ---------------------------------------------------------------
# 2. Branding laden (einzige Quelle: branding/branding.env)
# ---------------------------------------------------------------
# shellcheck disable=SC1091
source /ctx/branding/branding.env

# Setzt oder ersetzt einen Schlüssel in einer KEY="Wert"-Datei
set_kv() {
    local file="$1" key="$2" value="$3"
    if grep -q "^${key}=" "$file"; then
        sed -i "s|^${key}=.*|${key}=\"${value}\"|" "$file"
    else
        echo "${key}=\"${value}\"" >> "$file"
    fi
}

# os-release: sichtbarer Name des Systems (z. B. "Über dieses System" in KDE).
# ID, ID_LIKE, VARIANT_ID und IMAGE_NAME bleiben bewusst unverändert, weil
# Bazzite-Werkzeuge darauf zugreifen könnten. Prüfpunkt für den VM-Test.
OS_RELEASE="$(readlink -f /usr/lib/os-release)"
set_kv "${OS_RELEASE}" NAME "${ORBIS_OS_NAME}"
set_kv "${OS_RELEASE}" PRETTY_NAME "${ORBIS_OS_NAME} (basiert auf Bazzite)"
set_kv "${OS_RELEASE}" ORBIS_PROJECT "${ORBIS_PROJECT_NAME}"
set_kv "${OS_RELEASE}" ORBIS_BASE "bazzite"
# Logo-Name, Webseite, Fehlermeldungen und Standard-Rechnername (statt "bazzite").
# Der Rechnername gilt nur, solange keiner gesetzt ist (/etc/hostname leer).
# DOCUMENTATION_URL und SUPPORT_URL zeigen bewusst weiter auf Bazzite, deren Doku gilt für die Basis.
# BOOTLOADER_NAME (Text im Startmenü) bleibt vorerst unverändert: Bootloader-Themen nur mit Zustimmung.
set_kv "${OS_RELEASE}" LOGO "${ORBIS_OS_ID}-logo"
set_kv "${OS_RELEASE}" HOME_URL "${ORBIS_HOME_URL}"
set_kv "${OS_RELEASE}" BUG_REPORT_URL "${ORBIS_BUG_REPORT_URL}"
set_kv "${OS_RELEASE}" DEFAULT_HOSTNAME "${ORBIS_OS_ID}"

# Logo (ADR 0008) als Symbol ins System: alle Grössen plus SVG, dazu eine grosse Fassung
LOGO_SRC="/ctx/branding/logo"
for s in 16 22 24 32 48 64 128 256 512; do
    install -Dm644 "${LOGO_SRC}/png/zeichen-${s}.png" \
        "/usr/share/icons/hicolor/${s}x${s}/apps/${ORBIS_OS_ID}-logo.png"
done
install -Dm644 "${LOGO_SRC}/zeichen-farbe.svg" "/usr/share/icons/hicolor/scalable/apps/${ORBIS_OS_ID}-logo.svg"
install -Dm644 "${LOGO_SRC}/png/zeichen-512.png" "/usr/share/pixmaps/${ORBIS_OS_ID}-logo.png"

# KDE "Über dieses System" liest Name, Variante, Logo und Webseite nicht aus os-release,
# sondern aus /etc/xdg/kcm-about-distrorc. Bazzite trägt dort "Bazzite" ein (gefunden im
# VM-Test T001, 18.11.2026). Wir überschreiben die Datei mit Werten aus branding.env.
# Logo und Webseite seit 19.11.2026 eigene (ADR 0008).
KCM_ABOUT="/etc/xdg/kcm-about-distrorc"
cat > "${KCM_ABOUT}" <<EOF
[General]
Name=${ORBIS_OS_NAME}
Variant=${ORBIS_EDITION} (basiert auf Bazzite)
LogoPath=/usr/share/pixmaps/${ORBIS_OS_ID}-logo.png
Website=${ORBIS_HOME_URL}
EOF
cat "${KCM_ABOUT}"

# Branding-Datei ins System legen, damit spätere eigene Apps den Namen daraus lesen
install -Dm644 /ctx/branding/branding.env /usr/share/orbis/branding.env

# ---------------------------------------------------------------
# 3. Desktop-Design (Phase 2): Globales Design, Farbschemata, Hintergrund, Startbildschirm
# ---------------------------------------------------------------
# Quellen in desktop/ sind Vorlagen mit Platzhaltern (@OS_NAME@ usw.), damit der Name
# nur aus branding.env kommt. Siehe desktop/README.md.
DESK="/ctx/desktop"
render_tpl() {
    sed -e "s|@OS_NAME@|${ORBIS_OS_NAME}|g" \
        -e "s|@OS_ID@|${ORBIS_OS_ID}|g" \
        -e "s|@VENDOR@|${ORBIS_VENDOR}|g" \
        -e "s|@HOME_URL@|${ORBIS_HOME_URL}|g" \
        "$1" > "$2"
}

LNF="/usr/share/plasma/look-and-feel/org.${ORBIS_OS_ID}.desktop"
mkdir -p "${LNF}"
cp -a "${DESK}/look-and-feel/." "${LNF}/"
for f in metadata.json contents/defaults contents/layouts/org.kde.plasma.desktop-layout.js contents/splash/Splash.qml; do
    render_tpl "${DESK}/look-and-feel/${f}" "${LNF}/${f}"
done
install -Dm644 /ctx/branding/logo/zeichen-farbe.svg "${LNF}/contents/splash/images/logo.svg"

for s in Dunkel Hell; do
    render_tpl "${DESK}/color-schemes/${s}.colors" "/usr/share/color-schemes/${ORBIS_OS_NAME}${s}.colors"
done

WP="/usr/share/wallpapers/${ORBIS_OS_NAME}"
mkdir -p "${WP}"
cp -a "${DESK}/wallpaper/package/." "${WP}/"
render_tpl "${DESK}/wallpaper/package/metadata.json" "${WP}/metadata.json"

# Standard-Design für alle Benutzer: Bazzite setzt Valves "Vapor", wir setzen Orbis.
# Neue Benutzer bekommen Taskleiste und Hintergrund; bestehende Benutzer übernehmen
# Farben und Symbole, Taskleiste und Hintergrund erst über "Globales Design" anwenden.
sed -i "s|^LookAndFeelPackage=.*|LookAndFeelPackage=org.${ORBIS_OS_ID}.desktop|" /etc/xdg/kdeglobals
grep -q "^LookAndFeelPackage=org.${ORBIS_OS_ID}.desktop$" /etc/xdg/kdeglobals
find "${LNF}" "${WP}" -type f | sort
cat "${LNF}/contents/defaults"

# ---------------------------------------------------------------
# 4. Pakete
# ---------------------------------------------------------------
# Phase 1: keine zusätzlichen Pakete. Eigene Pakete kommen mit Phase 2 und 3.
# Beispiel: dnf5 install -y <paket>

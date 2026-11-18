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

# KDE "Über dieses System" liest Name, Variante, Logo und Webseite nicht aus os-release,
# sondern aus /etc/xdg/kcm-about-distrorc. Bazzite trägt dort "Bazzite" ein (gefunden im
# VM-Test T001, 18.11.2026). Wir überschreiben die Datei mit Werten aus branding.env.
# Logo: vorerst das vorhandene, ein Orbis-Logo folgt in Phase 2.
KCM_ABOUT="/etc/xdg/kcm-about-distrorc"
KCM_LOGO="$(sed -n 's/^LogoPath=//p' "${KCM_ABOUT}" 2>/dev/null || true)"
cat > "${KCM_ABOUT}" <<EOF
[General]
Name=${ORBIS_OS_NAME}
Variant=${ORBIS_EDITION} (basiert auf Bazzite)
${KCM_LOGO:+LogoPath=${KCM_LOGO}}
EOF
cat "${KCM_ABOUT}"

# Branding-Datei ins System legen, damit spätere eigene Apps den Namen daraus lesen
install -Dm644 /ctx/branding/branding.env /usr/share/orbis/branding.env

# ---------------------------------------------------------------
# 3. Pakete
# ---------------------------------------------------------------
# Phase 1: keine zusätzlichen Pakete. Eigene Pakete kommen mit Phase 2 und 3.
# Beispiel: dnf5 install -y <paket>

#!/usr/bin/bash
# Project Orbis – erzeugt PNG-Grössen des Logos aus den SVG-Vorlagen (ADR 0008).
# Ausführen nach jeder Änderung an den SVG-Dateien: branding/logo/render.sh
# Braucht rsvg-convert (Paket librsvg2-tools bzw. librsvg2-bin). Die PNGs werden mit eingecheckt,
# damit der Image-Build kein zusätzliches Werkzeug braucht.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p png
for s in 16 22 24 32; do
    rsvg-convert -w "$s" -h "$s" zeichen-klein.svg -o "png/zeichen-${s}.png"
done
for s in 48 64 128 256 512; do
    rsvg-convert -w "$s" -h "$s" zeichen-farbe.svg -o "png/zeichen-${s}.png"
done
ls -l png

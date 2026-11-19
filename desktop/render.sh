#!/usr/bin/bash
# Project Orbis – erzeugt alle Bilder des Desktop-Designs neu (Hintergründe, Vorschauen).
# Ausführen nach Änderungen an wallpaper/make_wallpaper.py. Braucht python3 und rsvg-convert.
# Die Ergebnisse werden eingecheckt, damit der Image-Build keine Zusatzwerkzeuge braucht.
set -euo pipefail
cd "$(dirname "$0")"
python3 wallpaper/make_wallpaper.py
# Wallpaper-Paket: images = hell, images_dark = dunkel (KDE wählt passend zum Farbschema)
rsvg-convert -w 3840 -h 2160 wallpaper/light.svg -o wallpaper/package/contents/images/3840x2160.png
rsvg-convert -w 3840 -h 2160 wallpaper/dark.svg -o wallpaper/package/contents/images_dark/3840x2160.png
rsvg-convert -w 640 -h 360 wallpaper/dark.svg -o wallpaper/package/contents/screenshot.png
# Vorschaubilder für "Globales Design" in den Systemeinstellungen
rsvg-convert -w 640 -h 360 wallpaper/dark.svg -o look-and-feel/contents/previews/preview.png
rsvg-convert -w 1920 -h 1080 wallpaper/dark.svg -o /tmp/orbis-fullpreview.png
python3 - <<'PY'
from pathlib import Path
import subprocess
subprocess.run(["convert", "/tmp/orbis-fullpreview.png", "-quality", "88",
                "look-and-feel/contents/previews/fullscreenpreview.jpg"], check=True)
PY
rm -f /tmp/orbis-fullpreview.png
du -sh wallpaper/package look-and-feel/contents/previews

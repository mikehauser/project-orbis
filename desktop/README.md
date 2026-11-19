# Desktop-Design (Phase 2)

Status: Version 1 implementiert, nicht getestet (19.11.2026).

Orbis gestaltet KDE Plasma über ein eigenes **Globales Design** (KDE "Look-and-Feel"-Paket),
wie in `docs/architecture/overview.md` vorgesehen. Kein KDE-Code wird verändert.

| Ordner | Wird im Image zu | Inhalt |
|---|---|---|
| `look-and-feel/` | `/usr/share/plasma/look-and-feel/org.<id>.desktop/` | Standardwerte (Farben, Symbole, Fensterrahmen), Taskleisten-Aufbau, Startbildschirm, Vorschaubilder |
| `color-schemes/` | `/usr/share/color-schemes/<Name>Dunkel.colors`, `<Name>Hell.colors` | Farbschemata aus dem Desktop-Entwurf (Akzent Türkis #5EEAD4, Violett #8B7CFF, Hell = "Papier" #F3EFE6) |
| `plasmoids/` | `/usr/share/plasma/plasmoids/org.<id>.<name>/` | eigene Plasma-Bauteile, z. B. `kommandozentrale` (Leiste oben, ADR 0009) |
| `wallpaper/` | `/usr/share/wallpapers/<Name>/` | Hintergrund "Umlaufbahn", hell und dunkel (KDE wählt passend zum Farbschema) |

- Textdateien sind **Vorlagen** mit Platzhaltern `@OS_NAME@`, `@OS_ID@`, `@VENDOR@`, `@HOME_URL@`.
  `image/build_files/build.sh` setzt die Werte aus `branding/branding.env` ein.
- Bilder werden mit `desktop/render.sh` neu erzeugt und eingecheckt.
- Die Datei `/etc/xdg/kdeglobals` von Bazzite wird so geändert, dass Orbis statt Valves "Vapor" das Standard-Design ist.

## Was Version 1 kann und was nicht
- Bedienkonzept "Kommandozentrale" (ADR 0009, ersetzt die schwebende Taskleiste unten aus Version 1): schmale, durchscheinende Leiste oben mit Kern-Knopf, Programmen, Systemwerten und Uhr. Super-Taste und Ecke oben links öffnen die Übersicht. Hinter dem Kern-Knopf steckt vorerst das KDE-Startmenü (Kickoff).
  Das eigene **Kern-Menü** aus dem Entwurf (Suche, Weiterspielen, Systemanzeige) ist eine eigene App und folgt später.
- Akzentfarbe: in KDE unter Systemeinstellungen > Farben frei wählbar.
- Eigene Schrift (Inter), Anmeldebildschirm (SDDM) und Start-Logo beim Hochfahren (Plymouth): folgen.
- Bestehende Benutzer übernehmen das Design nicht automatisch (Test T003). Anwenden mit
  `plasma-apply-lookandfeel -a org.orbis.desktop --resetLayout` oder Systemeinstellungen > Globales Design > Orbis
  mit Häkchen bei "Desktop- und Fensterlayout". Neue Benutzer bekommen es direkt.

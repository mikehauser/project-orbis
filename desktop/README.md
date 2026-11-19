# Desktop-Design (Phase 2)

Status: Version 1 implementiert, nicht getestet (19.11.2026).

Orbis gestaltet KDE Plasma über ein eigenes **Globales Design** (KDE "Look-and-Feel"-Paket),
wie in `docs/architecture/overview.md` vorgesehen. Kein KDE-Code wird verändert.

| Ordner | Wird im Image zu | Inhalt |
|---|---|---|
| `look-and-feel/` | `/usr/share/plasma/look-and-feel/org.<id>.desktop/` | Standardwerte (Farben, Symbole, Fensterrahmen), Taskleisten-Aufbau, Startbildschirm, Vorschaubilder |
| `color-schemes/` | `/usr/share/color-schemes/<Name>Dunkel.colors`, `<Name>Hell.colors` | Farbschemata aus dem Desktop-Entwurf (Akzent Türkis #5EEAD4, Violett #8B7CFF, Hell = "Papier" #F3EFE6) |
| `wallpaper/` | `/usr/share/wallpapers/<Name>/` | Hintergrund "Umlaufbahn", hell und dunkel (KDE wählt passend zum Farbschema) |

- Textdateien sind **Vorlagen** mit Platzhaltern `@OS_NAME@`, `@OS_ID@`, `@VENDOR@`, `@HOME_URL@`.
  `image/build_files/build.sh` setzt die Werte aus `branding/branding.env` ein.
- Bilder werden mit `desktop/render.sh` neu erzeugt und eingecheckt.
- Die Datei `/etc/xdg/kdeglobals` von Bazzite wird so geändert, dass Orbis statt Valves "Vapor" das Standard-Design ist.

## Was Version 1 kann und was nicht
- Schwebende, mittige Taskleiste mit Orbis-Logo als Knopf. Das Menü dahinter ist vorerst das KDE-Startmenü (Kickoff).
  Das eigene **Kern-Menü** aus dem Entwurf (Suche, Weiterspielen, Systemanzeige) ist eine eigene App und folgt später.
- Akzentfarbe: in KDE unter Systemeinstellungen > Farben frei wählbar.
- Glas-Effekt der Taskleiste, eigene Schrift (Inter), Anmeldebildschirm (SDDM) und Start-Logo beim Hochfahren (Plymouth): folgen.
- Bestehende Benutzer: Farben und Symbole wechseln automatisch, Taskleiste und Hintergrund erst über
  Systemeinstellungen > Globales Design > Orbis > Anwenden, mit Häkchen bei "Desktop- und Fensterlayout".

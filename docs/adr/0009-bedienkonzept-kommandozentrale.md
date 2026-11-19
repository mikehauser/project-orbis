# ADR 0009 – Bedienkonzept "Kommandozentrale" statt Taskleiste

- **Status:** entschieden am 19.11.2026 durch Mike ("B, mein Favorit").
- **Kontext:** Nach Desktop-Design v1 (schwebende Taskleiste unten, T003) Rückmeldung von Mike: "betreffend Taskleiste, das ist langweilig, was wir schon 30 Jahre haben". Drei Konzepte auf der Design-Fläche "Orbis Bedienkonzepte": A Orbit (Kern-Knopf, Apps fächern sich im Halbkreis auf), B Kommandozentrale (schmale Glasleiste oben wie ein Cockpit, Fensterwechsel über grosse Übersicht), C Startseite (Konsolen-Startbildschirm mit Kacheln).
- **Entscheidung:** **B · Kommandozentrale.** Empfehlung von Claude war A+B kombiniert. A und C bleiben als mögliche spätere Ergänzungen (z. B. C als Spielmodus).
- **Umsetzung Version 1 (KDE-Bordmittel, keine KDE-Änderung):**
  - Eine schwebende, durchscheinende Leiste oben (`panel.opacity = "translucent"`, KWin-Unschärfe dahinter), keine Leiste unten.
  - Links Kern-Knopf mit Orbis-Logo und Beschriftung "Suchen oder starten" (vorerst KDE-Startmenü Kickoff), Mitte Programme, rechts Systemwerte (KDE-Systemmonitor, Textanzeige: CPU, GPU, Temperatur), Symbole, Uhr.
  - Super-Taste und Ecke oben links öffnen die KWin-Übersicht mit Suchfeld (Standardwerte in `/etc/xdg/kwinrc`).
  - Dateien: `desktop/look-and-feel/contents/layouts/org.kde.plasma.desktop-layout.js`, `image/build_files/build.sh`.
- **Grenzen von Version 1:** Systemwerte und Leiste nutzen vorhandene KDE-Widgets, das Aussehen entspricht dem Entwurf nur ungefähr. Eigene Widgets (z. B. "Was läuft gerade" in der Mitte, Kern-Menü wie im Entwurf) folgen als eigene Komponenten. In der VM gibt es keinen GPU-Sensor (keine echte Grafikkarte), dort bleibt der GPU-Wert leer.
- **Status:** implementiert, nicht getestet.

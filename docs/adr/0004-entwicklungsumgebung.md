# ADR 0004 – Entwicklungsumgebung und Testweg

- **Status:** Vorschlag, noch nicht entschieden (18.11.2026)
- **Kontext:** Entwicklungsrechner: Windows 11 Pro. Projektordner `D:\Project-Orbis` (BitLocker-verschlüsselt). Repository `https://github.com/mikehauser/project-orbis.git` (privat). Image-Builds brauchen Linux-Werkzeuge (Podman, Just). Laufwerk C: hat nur ca. 30 GB frei (7 %). WSL2 und Hyper-V legen ihre virtuellen Festplatten standardmässig auf C: ab und würden das Laufwerk schnell füllen.
- **Entscheidung (Vorschlag):**
  1. **Builds in GitHub Actions** (CI zuerst). Kein lokales Linux nötig, nichts füllt C:. ISO wird als Download-Artefakt bereitgestellt. Grenzen der kostenlosen Runner (Plattenplatz, Minuten bei privaten Repositories) sind in Phase 1 zu prüfen.
  2. **Lokale WSL2-Umgebung nur bei Bedarf**, dann mit der Distribution auf D: (nicht auf C:).
  3. **Tests zuerst in einer Hyper-V-VM** (Entscheidung Mike, 18.11.2026: kein Dualboot für den Anfang). VM-Dateien liegen auf D:, nicht auf C:. Anleitung: `docs/testing/vm-test-anleitung.md`.
  4. **Tests auf echter Hardware später**, nur nach ausdrücklicher Freigabe: ISO auf USB-Stick (Mike hat 64 GB), Installation zunächst nur auf E: (siehe `docs/testing/echte-hardware-checkliste.md`).
- **Folgen:** Die VM zeigt Installer, Desktop, Design, Updates und Rollback, aber keine Grafikleistung, keine Spiele und keine Steuergeräte. Diese Punkte bleiben bis zum Test auf echter Hardware offen.
- **Offen:** Claude Code auf dem Windows-Rechner einrichten. Welche Kopie führend ist (Empfehlung: das GitHub-Repository).

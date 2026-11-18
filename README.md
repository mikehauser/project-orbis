# Project Orbis

Orbis ist ein eigenständiges Gaming- und Multimedia-Betriebssystem auf Linux-Basis
mit eigenem Desktop, eigenem Design und eigenem Update-Kanal.

**Status:** Phase 1 begonnen. Image-Definition und Build-Workflows sind geschrieben, aber **noch nie gebaut und nicht getestet**. Das Repository ist öffentlich (ADR 0006), der erste Build steht aus.
**Sichtbarkeit:** öffentliches Repository (Entscheidung 18.11.2026, ADR 0006). Der Name ist ein Arbeitsname, die Markenrecherche steht aus (siehe `docs/adr/0002-projektname.md`).

## Wo steht was

| Pfad | Inhalt |
|---|---|
| `CLAUDE.md` | Entwicklungsregeln, Sicherheitsregeln, Arbeitsweise |
| `docs/roadmap.md` | Phasen und Status (geplant / implementiert / getestet) |
| `docs/architecture/overview.md` | Schichtenmodell |
| `docs/adr/` | Architekturentscheidungen, eine Datei pro Entscheidung |
| `docs/hardware.md` | Referenz-Testsystem und Datenträger |
| `docs/testing/` | Testspiele, VM-Anleitung (optional), Checkliste für Tests auf echter Hardware |
| `branding/branding.env` | **Einzige** Stelle für Namen und Marke |
| `image/` | Containerfile, Build-Skript, eigene Systemdateien |
| `orbis-image.env`, `Justfile` | Parameter und Befehle für den Image-Build |
| `disk_config/iso.toml` | Konfiguration des Installers (ISO) |
| `.github/workflows/` | Cloud-Build (nur manuell gestartet) |
| `NOTICE`, `third_party/` | Herkunft und Lizenz übernommener Teile (Apache-2.0) |
| `desktop/`, `apps/`, `services/`, `compat-db/`, `installer/`, `tests/` | Noch leer, werden ab Phase 2 gefüllt |

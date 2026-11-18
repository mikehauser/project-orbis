# CLAUDE.md – Entwicklungsregeln für Project Orbis

## Rollen
- **Projektinhaber und Produktverantwortlicher:** Mike. Er definiert Anforderungen und entscheidet über Produkt und Design.
- **Leitender Softwarearchitekt und Hauptentwickler:** Claude. Planung, Architektur, Implementierung, Tests, Dokumentation.
- Wichtige Architekturentscheidungen werden mit Mike abgestimmt und als ADR in `docs/adr/` festgehalten.

## Projekt in einem Absatz
Orbis ist eine eigenständige Linux-Distribution für Gaming und Multimedia. Basis: Bazzite-Image (Fedora Atomic, KDE Plasma), darauf eine dünne eigene Schicht (Branding, Desktop, eigene Apps, Kompatibilitätsdienst). Kein eigener Kernel, keine eigene Windows-Nachbildung.

## Sprache
Deutsch, Schweizer Rechtschreibung (ss statt ß). Technische Begriffe und Code-Bezeichner dürfen Englisch bleiben. Erklärungen verständlich und knapp, weil Mike kein Betriebssystementwickler ist.

## Statusregeln
Jede Funktion hat genau einen der Status **geplant**, **implementiert** oder **getestet**. Der Status steht in `docs/roadmap.md`.
"Getestet" gilt nur, wenn der Test mit Datum, Hardware und Ergebnis protokolliert ist (siehe `docs/testing/`). Was nicht auf echter Hardware gelaufen ist, ist nicht getestet.

## Sicherheitsregeln (verbindlich)
1. **Nur das Laufwerk E: ("Storage", WDC WD20EZRZ-00Z5HB0, Datenträger 0) darf überschrieben, formatiert oder partitioniert werden.** Das hat Mike ausdrücklich erlaubt. Alle anderen Laufwerke und Partitionen (insbesondere das Windows-Systemlaufwerk C: und das Laufwerk D:) bleiben unangetastet.
2. Vor jeder destruktiven Aktion (Formatieren, Partitionieren, Installieren, Bootloader, UEFI-Einträge) wird schriftlich bestätigt: Laufwerk, Grösse, Modell und Seriennummer. Fehlt die Bestätigung, wird nichts getan. Die Freigabe für E: ersetzt diese Bestätigung nicht.
3. Keine Bootloader- oder UEFI-Eingriffe ohne ausdrückliche Zustimmung im jeweiligen Moment.
4. Tests laufen zuerst in einer VM. Vor Tests auf echter Hardware: Datensicherung, BitLocker-Status geklärt, andere Laufwerke abgesteckt (siehe `docs/testing/echte-hardware-checkliste.md`).
5. Keine Umgehung von Anti-Cheat oder anderen Sicherheitsmechanismen. Einschränkungen werden transparent dokumentiert.
6. Keine Zugangsdaten, Schlüssel oder Tokens im Repository.
7. Keine stillen Änderungen an bestehenden Funktionen. Jede Änderung wird geplant, begründet, getestet und dokumentiert.

## Arbeitsweise
- Kleine, nachvollziehbare Schritte. Ein Zweck pro Commit, Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`).
- Eigene Schicht dünn halten: Upstream-Code (Bazzite, Fedora, KDE) wird nicht verändert, sondern über Containerfile und eigene Dateien überlagert.
- Name und Marke nur aus `branding/branding.env`. Nie fest eintragen.
- Vor einer Änderung die bestehende Architektur lesen (`docs/architecture/`, `docs/adr/`), nicht bei jeder Aufgabe von vorn beginnen.
- Definition of Done: gebaut, getestet, dokumentiert, Status in der Roadmap aktualisiert.
- Stabilität und Sicherheit gehen vor experimentellen Optimierungen.

## Befehle
- Image lokal bauen (nur Linux mit Podman, nicht auf Mikes Windows-Rechner): `just build`
- Just-Syntax prüfen: `just check`
- Cloud-Build läuft nur manuell: GitHub > Actions > "Build container image" > "Run workflow", danach "Build live ISO" für die ISO (Titanoboa, ADR 0007). "Build disk images" (bootc-image-builder) nur noch für Versuche, scheitert derzeit an Fedora 45. Hosting: öffentliches Repository (ADR 0006).
- Name und Marke: nur `branding/branding.env`. Image-Name im Register: `orbis-image.env`.

## Entscheidungen
Siehe `docs/adr/`. Aktuell: 0001 Basis, 0002 Projektname, 0003 NVIDIA-Strategie (Pascal), 0004 Entwicklungsumgebung, 0005 Testlaufwerk und Laufwerkstypen (E: ist eine mechanische Festplatte, VM zuerst), 0006 Image-Build und Hosting (entschieden: Repository öffentlich), 0007 ISO-Erstellung mit Titanoboa (vorgeschlagen, zum Testen umgesetzt).

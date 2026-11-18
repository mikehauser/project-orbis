# Testprotokoll

Jeder Test mit Datum, Umgebung, Version und Ergebnis. Tests in einer VM zählen nach CLAUDE.md **nicht** als "getestet", sie sind Vorstufe. Erst Tests auf echter Hardware ändern den Status in der Roadmap.

## T001 – Erste Live-ISO in Hyper-V

- **Datum:** 18.11.2026
- **Getestet von:** Mike
- **Umgebung:** Hyper-V-VM Generation 2 (Anleitung `vm-test-anleitung.md`) auf Mikes PC (i7-8700K, 32 GB RAM, Windows 11), VM-Dateien auf D:
- **Version:** `orbis-live-latest-amd64.iso` aus Lauf 44366494330 (Commit cf4e8a2), SHA-256 `5cec63c2979c5f37af275ada7d12922050a113577e29549911c829bf00f5b034`

| Prüfpunkt | Ergebnis |
|---|---|
| ISO startet in der VM | ✅ ja (Mike, 18.11.2026) |
| Live-Sitzung mit Desktop | ✅ ja. Bemerkung Mike: Oberfläche sieht "übelst langweilig" aus (erwartet, Design folgt in Phase 2) |
| Installer startet | ✅ ja, Installation läuft |
| Installation läuft durch | offen |
| MOK-Schlüssel aufnehmen (Secure Boot) | offen |
| Installiertes System startet, Anmeldung | offen |
| Name "Orbis" in Systeminfo (os-release) | offen |
| Update und Rollback | offen |

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
| Installation läuft durch | ❌ nein (20:36). Anaconda-Fehler beim Einspielen des Images: `ostree container image deploy ... --transport=containers-storage` → `Unencapsulating base: failed to invoke method GetRawBlob: read /var/lib/containers/storage/overlay/c14b1f…/diff/sysroot/ostree/repo/objects/a5/ba3af9….file: input/output error`. Ursache (sehr wahrscheinlich): Die ISO wurde **während** der Installation aus dem virtuellen DVD-Laufwerk ausgeworfen. Die Live-Sitzung liest das zu installierende Image direkt von der ISO, ohne ISO entsteht ein Lesefehler. Bedienfehler, ausgelöst durch eine missverständliche Anleitung von Claude ("vor dem Neustart auswerfen"). Anleitung präzisiert. Wiederholung nötig. |
| Installation läuft durch (2. Versuch, ISO bis zum Ende eingelegt) | ✅ ja (installiertes System erreicht GRUB) |
| MOK-Schlüssel aufnehmen (Secure Boot) | ❌ Der blaue MOK-Bildschirm ist nicht erschienen (oder wurde übersprungen). Beim Start: `shim_lock_verifier_write: bad shim signature` und `you need to load the kernel first`. Bedeutung: Secure Boot ist an, der Universal-Blue-Schlüssel für den Bazzite-Kernel ist nicht aufgenommen, darum wird der Kernel abgelehnt. Ursache, warum MokManager nicht kam, offen. Weiter: Secure Boot in der VM vorübergehend aus, danach Schlüssel mit `ujust enroll-secure-boot-key` nachträglich aufnehmen. |
| Installiertes System startet, Anmeldung | ✅ ja, mit Secure Boot **aus** in der VM (21:05). Schlüsselaufnahme mit `ujust enroll-secure-boot-key` und Start mit Secure Boot an: später (Mike) |
| Name "Orbis" in Systeminfo (os-release) | ❌ KDE "Über dieses System" zeigt "Bazzite 45, Desktop Edition" (21:07). Ursache: KDE liest den Namen aus `/etc/xdg/kcm-about-distrorc`, das Bazzite mit "Bazzite" füllt, nicht aus os-release. Korrektur in Commit b727d2f, neuer Image-Build 44387820817. Prüfung über Update in der VM (`sudo bootc upgrade`). |
| Update-Quelle (`sudo bootc status`) | ✅ Booted image `ghcr.io/mikehauser/project-orbis:latest`, Digest `sha256:a34d7344…28e7`, Zeitstempel 2026-11-18T17:27:56Z (21:09). Updates kommen aus dem eigenen Image. |
| Update herunterladen (`sudo bootc upgrade`) | ✅ 19.11.2026: neues Image `sha256:28dadca8…4b54` (Lauf 44387820817) bereitgestellt ("Staged"), 3 neue Schichten, 343,4 MB |
| Update aktivieren und Rollback | offen. Erster Versuch: `bootc rollback` vor dem Neustart ausgeführt, dadurch war das Update noch nicht aktiv (Reihenfolge in der Anleitung präzisiert: Update, Neustart, prüfen, dann erst Rollback) |
| Nebenbefund | Rechnername des installierten Systems ist `localhost-live` (aus der Live-Sitzung übernommen). Später prüfen, ob Bazzite das gleich macht, und Standardnamen setzen. |

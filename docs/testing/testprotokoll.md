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
| Name "Orbis" in Systeminfo (os-release) | ✅ nach Korrektur und Update (siehe unten). Ursprünglich ❌ KDE "Über dieses System" zeigt "Bazzite 45, Desktop Edition" (21:07). Ursache: KDE liest den Namen aus `/etc/xdg/kcm-about-distrorc`, das Bazzite mit "Bazzite" füllt, nicht aus os-release. Korrektur in Commit b727d2f, neuer Image-Build 44387820817. Prüfung über Update in der VM (`sudo bootc upgrade`). |
| Update-Quelle (`sudo bootc status`) | ✅ Booted image `ghcr.io/mikehauser/project-orbis:latest`, Digest `sha256:a34d7344…28e7`, Zeitstempel 2026-11-18T17:27:56Z (21:09). Updates kommen aus dem eigenen Image. |
| Update herunterladen (`sudo bootc upgrade`) | ✅ 19.11.2026: neues Image `sha256:28dadca8…4b54` (Lauf 44387820817) bereitgestellt ("Staged"), 3 neue Schichten, 343,4 MB |
| Update aktivieren (Neustart) | ✅ 19.11.2026 11:10: Booted image `sha256:28dadca8…4b54`, Rollback image `a34d7344…28e7`. "Über dieses System" zeigt **Orbis 45, Prototyp (basiert auf Bazzite)**. Rest-Befunde: Webseiten-Link zeigt noch https://bazzite.gg (kommt aus os-release `HOME_URL`), Logo noch Bazzite (Phase 2), Rechnername jetzt `bazzite`. |
| Rollback (`sudo bootc rollback`, Neustart) | ✅ 19.11.2026 11:18: VM startet wieder die vorherige Version, "Über dieses System" zeigt "Bazzite 45, Desktop Edition" (altes Image `a34d7344…`). Zurückwechseln auf das neue Image: zweites `bootc rollback` (Rückmeldung offen). |
| Nebenbefund | Rechnername des installierten Systems ist `localhost-live` (aus der Live-Sitzung übernommen). Später prüfen, ob Bazzite das gleich macht, und Standardnamen setzen. |

## T002 – Orbis-Logo im System (Update in der VM)

- **Datum:** 19.11.2026, 12:20
- **Getestet von:** Mike
- **Umgebung:** gleiche Hyper-V-VM wie T001, Update mit `sudo bootc upgrade` und Neustart
- **Version:** Image aus Lauf 44509509063 (Commit 14c4548), Digest `sha256:e5b6b284…315e`

| Prüfpunkt | Ergebnis |
|---|---|
| "Über dieses System": Orbis-Logo, "Orbis 45", "Prototyp (basiert auf Bazzite)", Link zum Projekt | ✅ ja (Screenshot Mike) |
| Rechnername `orbis` | nicht geprüft |
| Rückmeldung Mike | "das hat er gemacht, aber die Idee ist ja ein komplett neues Desktop-Design" → nächster Schritt Desktop-Design (Phase 2) |


## T003 – Desktop-Design v1 (Update in der VM)

- **Datum:** 19.11.2026, 13:20
- **Getestet von:** Mike
- **Umgebung:** gleiche Hyper-V-VM wie T001/T002, bestehender Benutzer
- **Version:** Image aus Lauf 44514512621 (Commit e7de123), Digest `sha256:52557724…f355`

| Prüfpunkt | Ergebnis |
|---|---|
| Update aktiv | ✅ `bootc upgrade` meldet "No update available" für `525577…` |
| Design wechselt beim bestehenden Benutzer automatisch | ❌ nein, weiterhin Bazzite-Aussehen (Benutzer hat eigene gespeicherte Einstellungen). Erwartung in `desktop/README.md` war zu optimistisch (Farben sollten wechseln). |
| Design mit `plasma-apply-lookandfeel -a org.orbis.desktop --resetLayout` anwenden | ✅ 13:24, Screenshot Mike: Hintergrund "Umlaufbahn" (dunkel) sichtbar, Taskleiste schwebt mittig unten, Knopf mit Orbis-Logo, Browser, Steam, Dateien, Einstellungen, Symbole, Uhr. Fensterrahmen dunkel. |
| Befunde | Logo im Taskleisten-Knopf erscheint einfarbig weiss statt mit türkisem Gleiter. Taskleiste ist undurchsichtig (noch keine Glas-Optik). Startbildschirm noch nicht gesehen (erst nach Neuanmeldung). |
| Nebenbefund | Konsole zeigt beim Start weiterhin "Welcome to Bazzite" und `ghcr.io/ublue-os/bazzite:stable` (Bazzite-Begrüssung, ublue-motd) |
| Rückmeldung Mike vor dem Anwenden | "gefühlt immer noch dasselbe, langweilig" |

## T004 – Kommandozentrale Version 1 (VM)

- **Datum:** 19.11.2026, 14:53
- **Getestet von:** Mike
- **Version:** Image aus Lauf 44526615555 (Commit 4618297), Digest `sha256:260a33c4…6c97`

| Prüfpunkt | Ergebnis |
|---|---|
| Übersicht öffnen und darin suchen ("firefox") | ✅ Firefox wird gefunden |
| Aussehen wie Entwurf B | ❌ Mike: "sieht nicht annähernd so aus, wir sind noch immer bei der Taskleiste" → Version 2 mit eigenem Bauteil |

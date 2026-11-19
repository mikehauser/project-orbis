# Roadmap

Stand: 18. November 2026. Zeiten sind Grobschätzungen (±50 %).

| Phase | Inhalt | Status | Dauer |
|---|---|---|---|
| 0. Fundament | Repository, CLAUDE.md, ADRs, Entwicklungsumgebung (CI zuerst), Testweg auf E:, Markenrecherche | in Arbeit: Dateien liegen vor, E: identifiziert (Datenträger 0, WDC WD20EZRZ, mechanische Festplatte). Testweg: zuerst Hyper-V-VM auf D:. Offen: Hyper-V aktivieren, Repository-Upload, Markenrecherche, BitLocker-Status klären (vor echten Hardware-Tests) | 1–2 Wochen |
| 1. Basis-Image | Eigenes Image auf Bazzite-Basis, Branding, CI-Build, erste ISO | in Arbeit: Orbis-Image mit Branding (os-release) wird in GitHub Actions gebaut und in die GHCR geladen (erster erfolgreicher Build 18.11.2026; **gebaut, nicht getestet**). ISO über bootc-image-builder scheitert an Fedora 45 (ADR 0007), neuer Weg: Live-ISO mit Titanoboa wie Bazzite. Erste ISO am 18.11.2026 gebaut (Lauf 44366494330, 7,9 GB, SHA-256 `5cec63c2…f034`; **gebaut, nicht getestet**). Nächster Schritt: Test in der Hyper-V-VM | 3–6 Wochen |
| 2. Desktop-Erlebnis | Theme, Taskleiste, Kern-Menü, Hell/Dunkel, Plymouth, SDDM | in Arbeit: Logo "Abflug" entschieden (ADR 0008, Dateien in `branding/logo/`, noch nicht im System). Logo im System ("Über dieses System", Symbol, Webseite, Rechnername "orbis"): implementiert, nicht getestet. Desktop-Design v1 (Globales Design, Farbschemata Dunkel/Hell, Hintergrund, schwebende Taskleiste, Startbildschirm, siehe `desktop/README.md`): implementiert, nicht getestet. Danach: Anmeldebildschirm, Start-Logo, Schrift, Glas-Effekt, eigenes Kern-Menü | 3–5 Wochen |
| 3. Gaming v1 | Steam, Proton-Auswahl, Gaming-Modus, MangoHud, Profile, Testliste | geplant | 4–6 Wochen |
| MVP | Phasen 0–3 plus Basis-Apps, Updates, Rollback | geplant | ca. 3–4 Monate |
| 4. Eigene Apps | Einstellungszentrum, Gaming-Dashboard, Update-Manager | geplant | 8–12 Wochen |
| 5. Härtung | Installer, Wiederherstellung, Sicherheit, Beta | geplant | 4–6 Wochen |
| 6. Intelligenz | Kompatibilitätsdienst, Community-Daten | geplant | laufend |
| 7. Langzeit | Fedora-Rebase alle ~6 Monate, Dateimanager, Medien-Hub | geplant | laufend |

Langfristziel: Orbis ersetzt Windows auf der Haupt-SSD, sobald es kein Prototyp mehr ist (Entscheidung und Freigabe durch Mike, siehe ADR 0005).
Verteilung: zuerst privat und für Freunde, später öffentlich (ab Phase 5, nach Markenrecherche und Rechtsprüfung).
Design-Entwurf: Canvas "Desktop-Konzept" (drei Bildschirme: Desktop mit Kern-Menü, Gaming-Dashboard, Einstellungen). Status: Entwurf.

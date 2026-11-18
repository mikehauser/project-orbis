# Referenz-Testsystem (Mikes Rechner)

Quelle: Screenshots von GPU-Z, HWiNFO, Systeminformationen und Datenträgerverwaltung, 18.11.2026.

| Komponente | Wert |
|---|---|
| Prozessor | Intel Core i7-8700K, 6 Kerne / 12 Threads (Coffee Lake, Sockel 1151) |
| Hauptplatine | ASUS PRIME Z370-P, BIOS 0610 (11.01.2018), UEFI |
| Arbeitsspeicher | 32 GB DDR4 (2 × 16 GB Corsair, Doppelkanal) |
| Grafik | ASUS ROG STRIX GTX 1080 Ti GAMING OC, 11 GB GDDR5X (Pascal, GP102) |
| Laufwerke | WDC WD20EZRZ 2 TB (SATA, mechanisch), Samsung SSD 960 EVO 500 GB (NVMe), Kingston SFYRDK2000G 2 TB (NVMe) |
| Betriebssystem | Windows 11 Pro Build 26200 (25H2) |
| Boot | UEFI, Secure Boot **aktiviert**, HVCI deaktiviert, VBS nicht aktiv |
| Virtualisierung | VT-x vorhanden, Hyper-V-Monitor-Modus unterstützt |
| Steuergeräte (MSFS) | Thrustmaster Airbus Sidestick mit Schubregler, Velocity-Pedale |

## Datenträger (Datenträgerverwaltung, 18.11.2026)

| Datenträger | Grösse | Inhalt | BitLocker | Hinweis |
|---|---|---|---|---|
| 0 | 1863 GB | **Storage (E:)**, eine NTFS-Partition (aktiv, primär), ca. 1793 GB frei | nein | **Für Orbis-Tests freigegeben.** Eine ganze Platte, keine Systempartition. Modell: **WDC WD20EZRZ-00Z5HB0, mechanische Festplatte (HDD)**, Bus 1 / Target 0 (laut Mike, 18.11.2026). |
| 1 | 465,75 GB | EFI-Systempartition (200 MB), Windows 11 Pro (C:) 464,71 GB, weitere Partition 861 MB (vermutlich Wiederherstellung) | laut Screenshot ja, laut Mike nein (ungeklärt) | Boot-Laufwerk von Windows. **Nicht anfassen.** Nur ca. 30 GB frei (7 %). Nach Grösse die Samsung 960 EVO. |
| 2 | 1863 GB | Games (D:), NTFS, ca. 814 GB frei, enthält den Projektordner | laut Screenshot ja, laut Mike nein (ungeklärt) | **Nicht anfassen.** Nach Ausschlussverfahren die Kingston-NVMe. |

Folge: E: ist eine mechanische Festplatte. Sie genügt für Boot-, Installer- und Design-Tests, ist aber deutlich langsamer als NVMe und für Leistungstests mit dem Flight Simulator nicht aussagekräftig (siehe ADR 0005).

BitLocker: Die Datenträgerverwaltung (18.11.2026) zeigt C: und D: als "BitLocker-verschlüsselt". Mike sagt, sie seien nicht verschlüsselt. Windows 11 aktiviert die "Geräteverschlüsselung" teils automatisch (z. B. mit Microsoft-Konto). Klärung vor einem Test auf echter Hardware mit `manage-bde -status` (Administrator-Eingabeaufforderung).
USB-Stick: 64 GB vorhanden.

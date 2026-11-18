# Checkliste: Test auf echter Hardware (nur nach ausdrücklicher Freigabe im jeweiligen Moment)

Reihenfolge: zuerst VM-Tests (siehe `vm-test-anleitung.md`). Diese Checkliste gilt erst, wenn Mike echte Hardware freigibt.

Freigegeben ist ausschliesslich Laufwerk **E: ("Storage")**. Alles andere bleibt unangetastet.

## Vorher (alles muss abgehakt sein)
- [ ] Datensicherung der Daten auf E: auf ein anderes Laufwerk oder extern.
- [x] E: ist eine eigene physische Platte (Datenträger 0, 1863 GB, eine NTFS-Partition, nicht verschlüsselt). Bestätigt per Datenträgerverwaltung am 18.11.2026.
- [x] Modell von Datenträger 0 (E:): WDC WD20EZRZ-00Z5HB0, mechanische Festplatte, Bus 1 / Target 0 (laut Mike, 18.11.2026). **Vor der Installation Seriennummer und Grösse im Installer erneut abgleichen.**
- [ ] **BitLocker-Status von C: und D: geklärt** (`manage-bde -status`). Die Datenträgerverwaltung zeigt "BitLocker-verschlüsselt", Mike sagt nein. Falls verschlüsselt: Wiederherstellungsschlüssel extern sichern, bevor Boot-Reihenfolge oder Laufwerke geändert werden.
- [x] USB-Stick vorhanden (64 GB, ausreichend für ISOs von ca. 7 bis 9 GB).
- [ ] Alle anderen Laufwerke vom Strom/SATA-/NVMe-Anschluss getrennt oder im UEFI deaktiviert, damit der Installer nur E: sieht.
- [ ] Startmedium (USB) erstellt, UEFI-Bootmenü-Taste bekannt.
- [ ] Windows-Wiederherstellungsmedium vorhanden.

## Installation
- Nur Zielplatte E:. Bootloader und EFI-Partition ausschliesslich auf dieser Platte.
- Vor dem Bestätigen im Installer: Laufwerk, Modell, Grösse, Seriennummer schriftlich abgleichen.

## Danach
- Windows startet ohne Eingriff? (Ja/Nein, Datum)
- Ergebnis, Hardware, Version in `docs/testing/` protokollieren.

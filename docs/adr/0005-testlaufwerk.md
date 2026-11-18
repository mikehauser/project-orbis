# ADR 0005 – Testlaufwerk und Laufwerkstypen

- **Status:** Vorschlag (18.11.2026, überarbeitet nach Rückmeldung von Mike)
- **Kontext:** Freigegeben für spätere Tests auf echter Hardware ist ausschliesslich E: ("Storage"), die WDC WD20EZRZ-00Z5HB0, eine mechanische 2-TB-Festplatte. Mike möchte zuerst in einer VM testen (kein Dualboot für den Anfang). Langfristig soll Orbis Windows auf der Haupt-SSD ersetzen, sobald es kein Prototyp mehr ist.
- **Entscheidung:**
  1. **Orbis wird für SSD und Festplatte gleichermassen lauffähig sein.** Das ist bei Linux Standard und braucht keine Sonderentwicklung. Der Installer legt das Dateisystem an, Trim für SSDs läuft automatisch. Auf einer Festplatte läuft das System nur langsamer.
  2. **Reihenfolge der Tests:** (a) VM auf D:, (b) später echte Hardware auf E:, (c) erst danach, wenn Orbis kein Prototyp mehr ist, eine Installation auf der Haupt-SSD durch Mike.
  3. Leistungsergebnisse von der VM oder von der Festplatte sind für Spiele nicht aussagekräftig und werden so gekennzeichnet. Für Phase 3 (Gaming) ist ein Test auf einer SSD sinnvoll.
  4. Die Freigabe gilt weiterhin nur für E:. Jedes weitere Laufwerk, auch die Haupt-SSD, braucht eine neue, ausdrückliche Freigabe von Mike.
- **Folgen für den späteren Umstieg:** Steam-Spielebibliotheken unter Proton sollten nicht auf NTFS liegen. Beim Wechsel müsste Laufwerk D: (Games) nach einer Sicherung neu formatiert werden. Das wird vor dem Umstieg gemeinsam geplant, nicht vorher.

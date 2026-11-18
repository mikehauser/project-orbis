# ADR 0003 – NVIDIA-Strategie (Pascal-Referenzkarte)

- **Status:** vorgeschlagen
- **Kontext:** Referenzsystem hat eine GeForce GTX 1080 Ti (Pascal). NVIDIA führt Maxwell, Pascal und Volta im Legacy-Zweig 580, der die letzte Linux-Treiberlinie für diese Karten ist. Spätere Zweige (ab 590) unterstützen Pascal nicht mehr. Für die Legacy-Linie sind laut Berichten bis Oktober 2028 nur noch Sicherheitsupdates vorgesehen. Bazzite bietet ein eigenes Legacy-NVIDIA-Image (Bazzite mit festgepinntem 580-Treiber) und einen Image-Picker mit Legacy-NVIDIA-Option. Der Legacy-ISO-Weg nutzt laut Forum den älteren Anaconda-Installer ohne Live-Desktop. Quelle: Universal-Blue-Forum und ComputerBase-Downloadseite, 18.11.2026. Noch auf einem echten System zu verifizieren.
- **Entscheidung:** Orbis liefert zwei Grafik-Varianten: Mesa (AMD/Intel) und NVIDIA proprietär. Für Pascal wird die 580-Legacy-Linie als eigene Variante geführt. Die 1080 Ti ist das erste Testsystem, aber nicht das einzige Referenzsystem. Mindestens eine AMD-Karte oder neuere NVIDIA-Karte (z. B. bei Freunden) kommt in die Testmatrix.
- **Offene Prüfpunkte:** Läuft Proton Experimental mit DXVK 3.x auf Pascal (benötigt Vulkan-1.4-Treiber)? Steam und die Legacy-Treiber auf Bazzite 45? Secure Boot mit NVIDIA-Modulen?
- **Folgen:** Pascal-Support ist zeitlich begrenzt. Das wird dokumentiert und in der Kompatibilitätsanzeige sichtbar.

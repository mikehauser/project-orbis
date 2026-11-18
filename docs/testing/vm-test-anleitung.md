# Test-VM mit Hyper-V (Standard-Testweg, Anleitung, Status: geplant, nicht getestet)

Hinweis: Seit 18.11.2026 ist die VM der erste Testweg (siehe ADR 0004). Wegen wenig Platz auf C: (ca. 30 GB frei) alle VM-Dateien auf D: ablegen.

Zweck: Installer, Desktop, Design, Updates und Rollback gefahrlos testen. **Nicht** geeignet für Spiele oder Grafikleistung (keine echte GPU).

## Vorbereitung
1. Windows-Features: "Hyper-V" aktivieren (Windows 11 Pro). Neustart.
2. Mindestens 100 GB freier Platz auf einem Laufwerk, das **nicht** E: sein muss (D: eignet sich).

## VM anlegen (Hyper-V-Manager)
1. Neu > Virtueller Computer, **Generation 2**.
2. Arbeitsspeicher: 8 GB (statischer Speicher), virtuelle CPU: 4.
3. Virtuelle Festplatte: 80 GB, Ort: `D:\VMs\orbis-test`.
4. Netzwerk: "Default Switch".
5. Einstellungen > Sicherheit > Secure Boot: Vorlage **"Microsoft UEFI-Zertifizierungsstelle"** wählen (für Linux nötig). Zum Fehlersuchen darf Secure Boot vorübergehend aus sein.
6. ISO als DVD-Laufwerk einlegen, von DVD starten.
7. **Image-Variante für die VM:** die normale Variante (Mesa, ohne NVIDIA). Die VM hat keine NVIDIA-Karte, die NVIDIA-Images sind dort nicht sinnvoll.

## Nach jedem Test
Prüfpunkte: bootet, Installer läuft, Anmeldung, Desktop, Update, Rollback. Ergebnis in `docs/testing/` mit Datum protokollieren.
Prüfpunkte, die die VM **nicht** zeigt: Grafikleistung, Spiele, Steuergeräte, echter Secure-Boot-Pfad mit NVIDIA.

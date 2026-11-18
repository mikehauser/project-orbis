# Architektur – Überblick (geplant)

Schichten von unten nach oben:

1. Firmware: UEFI, Secure Boot, TPM
2. Linux-Kernel (aus dem Bazzite-Image)
3. Basis-Image: Fedora Atomic + Bazzite (unveränderliches System, atomare Updates, Rollback)
4. Systemdienste: Mesa, NVIDIA-Treiber, PipeWire, Wayland, NetworkManager, BlueZ, CUPS/SANE
5. Gaming-Stack: Steam, Proton, gamescope, MangoHud, GameMode
6. Desktop: KDE Plasma 6 plus eigene Shell-Pakete (Look-and-Feel, Kern-Menü, Taskleiste, SDDM, Plymouth)
7. Eigene Anwendungen: Einstellungen, Gaming-Dashboard, Kompatibilitäts-Assistent, Update-Manager

Grundsätze: eigene Schicht dünn halten, Oberfläche und Dienste über D-Bus trennen, jedes Release in CI bauen, signieren und mit SBOM versehen.

Technologie: Containerfile, Just, Shell, YAML für das Image. Qt 6, QML, Kirigami für Oberflächen. Rust für Hintergrunddienste. Git, Conventional Commits, CalVer.

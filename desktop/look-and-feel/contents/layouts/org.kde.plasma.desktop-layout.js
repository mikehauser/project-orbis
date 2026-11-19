// Project Orbis – Desktop-Aufbau "Kommandozentrale" (ADR 0009).
// Statt einer Taskleiste unten gibt es oben eine schmale, schwebende Glasleiste:
//   links:  Orbis-Logo als Kern-Knopf (vorerst KDE-Startmenü "Kickoff") mit Suche
//   Mitte:  laufende und angeheftete Programme
//   rechts: CPU, GPU, Temperatur, Symbole, Uhr
// Fenster wechseln: Super-Taste oder Ecke oben links öffnet die Übersicht (KWin),
// eingestellt in /etc/xdg/kwinrc durch image/build_files/build.sh.
// Gilt für neue Benutzer und beim Anwenden des Globalen Designs mit Layout.

var panel = new Panel;
panel.location = "top";
panel.floating = true;
panel.lengthMode = "fill";
panel.opacity = "translucent";
panel.hiding = "none";
panel.height = 2 * Math.ceil(gridUnit * 2.2 / 2);

var kern = panel.addWidget("org.kde.plasma.kickoff");
kern.currentConfigGroup = ["General"];
kern.writeConfig("icon", "/usr/share/icons/hicolor/scalable/apps/@OS_ID@-logo.svg");
kern.writeConfig("menuLabel", "Suchen oder starten");

panel.addWidget("org.kde.plasma.panelspacer");

var tasks = panel.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "preferred://browser",
    "applications:steam.desktop",
    "preferred://filemanager",
    "applications:systemsettings.desktop"
]);

panel.addWidget("org.kde.plasma.panelspacer");

var monitor = panel.addWidget("org.kde.plasma.systemmonitor");
monitor.currentConfigGroup = ["Appearance"];
monitor.writeConfig("chartFace", "org.kde.ksysguard.textonly");
monitor.writeConfig("title", "System");
monitor.writeConfig("showTitle", false);
monitor.currentConfigGroup = ["Sensors"];
monitor.writeConfig("highPrioritySensorIds", '["cpu/all/usage","gpu/all/usage","cpu/all/averageTemperature"]');

panel.addWidget("org.kde.plasma.marginsseparator");
panel.addWidget("org.kde.plasma.systemtray");
panel.addWidget("org.kde.plasma.digitalclock");

var desktopsArray = desktopsForActivity(currentActivity());
for (var j = 0; j < desktopsArray.length; j++) {
    var d = desktopsArray[j];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    d.writeConfig("Image", "file:///usr/share/wallpapers/@OS_NAME@/");
}

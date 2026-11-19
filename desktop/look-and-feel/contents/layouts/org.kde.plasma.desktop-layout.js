// Project Orbis – Desktop-Aufbau: schwebende, mittige Taskleiste mit dem Orbis-Logo
// als Knopf für das Kern-Menü (vorerst das KDE-Startmenü "Kickoff"), dazu das
// Orbis-Hintergrundbild. Gilt für neue Benutzer und beim Anwenden des Globalen
// Designs mit "Desktop- und Fensterlayout".

var panel = new Panel;
panel.location = "bottom";
panel.floating = true;
panel.alignment = "center";
panel.lengthMode = "fit";
panel.hiding = "none";
panel.height = 2 * Math.ceil(gridUnit * 2.8 / 2);

var kern = panel.addWidget("org.kde.plasma.kickoff");
kern.currentConfigGroup = ["General"];
kern.writeConfig("icon", "@OS_ID@-logo");

var tasks = panel.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "preferred://browser",
    "applications:steam.desktop",
    "preferred://filemanager",
    "applications:systemsettings.desktop"
]);

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

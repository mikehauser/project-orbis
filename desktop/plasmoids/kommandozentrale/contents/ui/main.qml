// Project Orbis – Kommandozentrale (ADR 0009), Version 1.
// Eigenes Bauteil für die Leiste oben, gestaltet nach dem Entwurf "B · Kommandozentrale":
//   Suchfeld (öffnet die Suche), Mitte: was gerade läuft (Klick: Übersicht),
//   rechts: CPU, GPU, Temperatur als Glas-Pillen. Werte, die es nicht gibt
//   (z. B. GPU in einer VM), werden ausgeblendet.
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.taskmanager as TaskManager

PlasmoidItem {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: fullRepresentation
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumWidth: Kirigami.Units.gridUnit * 30

    readonly property color textColor: Kirigami.Theme.textColor
    readonly property color dimColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.7)
    readonly property color accent: Kirigami.Theme.highlightColor
    readonly property color pillColor: Qt.rgba(1, 1, 1, 0.07)
    readonly property color pillHover: Qt.rgba(1, 1, 1, 0.13)
    readonly property color pillBorder: Qt.rgba(1, 1, 1, 0.12)
    readonly property int pillHeight: Math.max(Kirigami.Units.gridUnit * 1.5, Math.min(height - 8, Kirigami.Units.gridUnit * 2.1))

    // Befehle über D-Bus: Suche (KRunner) und Übersicht (KWin)
    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => disconnectSource(sourceName)
    }
    function run(cmd) { executable.connectSource(cmd) }
    function openSearch() {
        run("dbus-send --session --type=method_call --dest=org.kde.krunner /App org.kde.krunner.App.display")
    }
    function openOverview() {
        run("dbus-send --session --type=method_call --dest=org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut string:Overview")
    }

    // Was läuft gerade: das aktive Fenster
    TaskManager.TasksModel {
        id: tasksModel
        groupMode: TaskManager.TasksModel.GroupDisabled
    }
    readonly property string activeApp: {
        const idx = tasksModel.activeTask;
        if (!idx || !idx.valid) {
            return "";
        }
        return tasksModel.data(idx, TaskManager.AbstractTasksModel.AppName)
            || tasksModel.data(idx, Qt.DisplayRole) || "";
    }

    // Systemwerte
    Sensors.Sensor { id: cpuSensor; sensorId: "cpu/all/usage"; updateRateLimit: 2000 }
    Sensors.Sensor { id: gpuSensor; sensorId: "gpu/all/usage"; updateRateLimit: 2000 }
    Sensors.Sensor { id: tempSensor; sensorId: "cpu/all/averageTemperature"; updateRateLimit: 4000 }

    component Pill: Rectangle {
        property bool hovered: false
        implicitHeight: root.pillHeight
        radius: height / 2
        color: hovered ? root.pillHover : root.pillColor
        border.width: 1
        border.color: root.pillBorder
        Behavior on color { ColorAnimation { duration: Kirigami.Units.shortDuration } }
    }

    component SensorPill: Pill {
        id: sp
        property string label
        property var sensor
        visible: sensor.status === Sensors.Sensor.Ready && sensor.value !== undefined && sensor.value !== null
        implicitWidth: sensorRow.implicitWidth + Kirigami.Units.largeSpacing * 2
        RowLayout {
            id: sensorRow
            anchors.centerIn: parent
            spacing: Kirigami.Units.smallSpacing
            Text { text: sp.label; color: root.dimColor; font: Kirigami.Theme.smallFont }
            Text {
                text: sp.sensor.formattedValue
                color: root.textColor
                font.family: Kirigami.Theme.defaultFont.family
                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                font.weight: Font.DemiBold
            }
        }
    }

    fullRepresentation: Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        // Links: Suche
        Pill {
            id: search
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: Math.min(Kirigami.Units.gridUnit * 16, parent.width * 0.3)
            hovered: searchArea.containsMouse
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Kirigami.Units.largeSpacing
                anchors.rightMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing * 2
                Kirigami.Icon {
                    source: "search"
                    Layout.preferredWidth: Kirigami.Units.iconSizes.small
                    Layout.preferredHeight: Kirigami.Units.iconSizes.small
                    color: root.dimColor
                    isMask: true
                }
                Text {
                    Layout.fillWidth: true
                    text: "Suchen oder starten …"
                    color: root.dimColor
                    elide: Text.ElideRight
                    font: Kirigami.Theme.defaultFont
                }
            }
            MouseArea {
                id: searchArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openSearch()
            }
        }

        // Mitte: was läuft gerade
        Pill {
            id: status
            anchors.centerIn: parent
            width: statusRow.implicitWidth + Kirigami.Units.largeSpacing * 3
            hovered: statusArea.containsMouse
            RowLayout {
                id: statusRow
                anchors.centerIn: parent
                spacing: Kirigami.Units.smallSpacing * 2
                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: root.accent
                    opacity: root.activeApp !== "" ? 1 : 0.4
                }
                Text {
                    text: root.activeApp !== "" ? root.activeApp + " läuft" : "Bereit"
                    color: root.textColor
                    font: Kirigami.Theme.defaultFont
                    elide: Text.ElideRight
                    Layout.maximumWidth: Kirigami.Units.gridUnit * 20
                }
            }
            MouseArea {
                id: statusArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openOverview()
            }
        }

        // Rechts: Systemwerte
        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Kirigami.Units.smallSpacing * 2
            SensorPill { label: "CPU"; sensor: cpuSensor }
            SensorPill { label: "GPU"; sensor: gpuSensor }
            SensorPill { label: "Temp"; sensor: tempSensor }
        }
    }
}

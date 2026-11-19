// Project Orbis – Startbildschirm nach der Anmeldung (KSplash):
// Logo, Name in weiten Grossbuchstaben, schmaler Fortschrittsbalken.
import QtQuick

Rectangle {
    id: root
    color: "#07090F"

    property int stage

    onStageChanged: {
        if (stage == 2) {
            introAnimation.running = true
        }
    }

    Item {
        id: content
        anchors.centerIn: parent
        width: 360
        height: 300
        opacity: 0

        Image {
            id: logo
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            source: "images/logo.svg"
            sourceSize.width: 150
            sourceSize.height: 150
        }

        Text {
            id: name
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: logo.bottom
            anchors.topMargin: 28
            text: "@OS_NAME@"
            color: "#E8EBF4"
            font.pixelSize: 26
            font.letterSpacing: 10
            font.capitalization: Font.AllUppercase
            font.weight: Font.Medium
        }

        Rectangle {
            id: track
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: 160
            height: 3
            radius: 2
            color: "#1F2433"

            Rectangle {
                height: parent.height
                radius: 2
                color: "#5EEAD4"
                width: parent.width * Math.min(root.stage, 6) / 6
                Behavior on width {
                    NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 600
        easing.type: Easing.InOutQuad
    }
}

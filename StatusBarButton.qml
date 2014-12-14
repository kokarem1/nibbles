import QtQuick 2.0

Rectangle {
    property alias mouseArea: buttonMA
    property alias caption: buttonText

    radius: (2/5) * height
    gradient:
        Gradient {
            GradientStop { position: 0.0; color: "lightgray" }
            GradientStop { position: 0.4; color: "steelblue" }
            GradientStop { position: 1.0; color: "blue" }
        }

    border.width: 2
    border.color: "gray"
    scale: buttonMA.pressed? 0.88: 1

    Text {
        id: buttonText

        anchors.centerIn: parent
        font.pixelSize: parent.height / 2
        color: "white"
        //style: Text.Outline
    }

    MouseArea {
        id: buttonMA

        anchors.fill: parent
    }
}

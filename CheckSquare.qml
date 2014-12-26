import QtQuick 2.0

Rectangle {
    property bool checked: true

    height: parent.height
    width: height
    border.width: 1
    border.color: "darkblue"

    Text {
        id: text

        anchors.centerIn: parent
        font.pixelSize: (9/10) * parent.height
        text: "✓"
        visible: checked
        color: "darkblue"
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            checked = ! checked
        }
    }
}

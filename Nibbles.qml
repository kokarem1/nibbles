import QtQuick 2.0

Rectangle {

    property int horizontalCellsCount: 10 // Not correct, ...
    property int verticalCellsCount: 10   // ... should be set in Haskell code // Something bad if 10:100 statusBar text

    property int widthResolution: 500
    property int heightResolution: 500

    property string scoreText: "Score: 0"
    property string speedText: "Speed: " + 1
    property string newSpeedText: "Speed: " + 2

    function calculateCellSize()
    {
        var widthCellSize = widthResolution / horizontalCellsCount;
        var heightCellSize = (heightResolution - statusBar.height) / verticalCellsCount;
        return widthCellSize < heightCellSize? widthCellSize: heightCellSize;
    }

    property int cellSize: calculateCellSize()

    id: canvas
    width: widthResolution
    height: heightResolution
    color: "lightblue"

    Column {
        anchors.centerIn: parent

        Rectangle {
            id: gameFieldRectangle

            width: cellSize * horizontalCellsCount
            height: cellSize * verticalCellsCount

            Grid {
                id: gameField
                anchors.fill: parent
                columns: horizontalCellsCount
                rows: verticalCellsCount
                focus: true

                Repeater {
                    model: listModel
                    delegate: gameFieldsCell
                }

                Component {
                    id: gameFieldsCell
                    Rectangle {
                        width: cellSize
                        height: cellSize

                        color:
                            if (column)
                                "sandybrown"
                            else
                                "green"

                        border.width: gridCheckSquare.checked? 1: 0
                    }
                }

                ListModel {id: listModel}

                Component.onCompleted: {
                    for (var i = 0; i < verticalCellsCount; ++i)
                        for (var j = 0; j < horizontalCellsCount; ++j)
                            listModel.append( {row: i, column: j} )
                }
            }
        }

        Rectangle {
            id: statusBar
            width: gameField.width
            height: heightResolution / 10
            gradient:
                Gradient {
                    GradientStop { position: 0.0; color: "lightgray" }
                    GradientStop { position: 0.33; color: "red" }
                    GradientStop { position: 0.66; color: "yellow" }
                    GradientStop { position: 1.0; color: "green" }
                }
            border.width: 1

            Row {
                id: statusBarRow
                anchors.centerIn: statusBar
                spacing: statusOpacityTransition.running? statusBar.width / 8: statusBar.width / 20

                Text {
                    id: scoreCaptionSB

                    text: scoreText
                    font.pixelSize: statusBar.width / 20
                    font.bold: true
                    visible: statusOpacityTransition.running
                }

                Rectangle {
                    width: (3/5) * statusBar.height
                    height: width
                    visible: statusOpacityTransition.running
                    border.width: 1
                    color: "sandybrown"
                }

                Component.onCompleted: {
//                    for (var x in statusBarRow.children)
//                        console.log(statusBarRow.children[x].visible)
                    state = "gameover"
                }

                Text {
                    id: speedCaptionSB

                    text: speedText
                    font.pixelSize: statusBar.width / 20
                    visible: statusOpacityTransition.running
                }

                Text {
                    id: newSpeedCaptionSB

                    text: newSpeedText
                    font.pixelSize: statusBar.width / 20
                    visible: ! statusOpacityTransition.running
                }

                Rectangle {
                    width: statusBar.width / 22
                    height: (2/3) * statusBar.height
                    color: "transparent"
                    visible: ! statusOpacityTransition.running

                    StatusBarButton {
                        width: parent.width
                        height: (4/9) * parent.height
                        anchors.top: parent.top
                        caption.text: "▲"

                        mouseArea.onClicked: {
                        }
                    }

                    StatusBarButton {
                        width: parent.width
                        height: (4/9) * parent.height
                        anchors.bottom: parent.bottom
                        caption.text: "▼"

                        mouseArea.onClicked: {
                        }
                    }
                }

                StatusBarButton {
                    width: statusBar.width / 4
                    height: (2/3) * statusBar.height

                    caption.text: "New Game"
                    visible: ! statusOpacityTransition.running
                }

                StatusBarButton {
                    height: (2/3) * statusBar.height
                    width: height
                    caption.text: "⚙"
                    visible: ! statusOpacityTransition.running

                    mouseArea.onClicked: {
                        optionsMenu.state = "active"
                    }
                }

                states: State {
                    name: "gameover";
                    //PropertyChanges { target: scoreCaptionSB; opacity: 0 }
                    //PropertyChanges { target: speedCaptionSB; opacity: 0 }
                    PropertyChanges { target: scoreCaptionGO; opacity: 1 }
                    PropertyChanges { target: speedCaptionGO; opacity: 1 }
                }

                transitions: Transition {
                    id: statusOpacityTransition

                    NumberAnimation { properties: "opacity"; easing.type: Easing.InCubic; duration: 2000 }
                }
            }
        }
    }

    Rectangle {
        id: gameOverRectangle
        x: canvas.width
        width: 2 * gameField.width / 3
        height: gameField.height / 4
        color: "black"
        anchors.verticalCenter: canvas.verticalCenter

        Row {
            spacing: gameOverRectangle.width / 8
            anchors.horizontalCenter: gameOverRectangle.horizontalCenter
            anchors.bottom: gameOverRectangle.bottom
            anchors.bottomMargin: gameOverRectangle.height / 12

            Text {
                id: scoreCaptionGO

                text: scoreText
                font.pixelSize: gameOverRectangle.height / 6
                color: "lightgreen"

                opacity: 0
            }

            Text {
                id: speedCaptionGO

                text: speedText
                font.pixelSize: gameOverRectangle.height / 6
                color: "lightgreen"

                opacity: 0
            }
        }

        states: State {
            name: "gameover";
            PropertyChanges { target: gameOverRectangle; x: canvas.width / 2 - gameOverRectangle.width / 2 }
        }

        transitions: Transition {
            id: aaa
            NumberAnimation { properties: "x"; easing.type: Easing.InCubic; duration: 500 }
        }

        Component.onCompleted: {
            gameOverRectangle.state = "gameover"
        }
    }

    Rectangle {
        property int wordSpacing: textGame.font.pixelSize / 3

        width: textGame.width + textOver.width + wordSpacing
        height: textGame.height
        color: "transparent"
        anchors.centerIn: gameOverRectangle

        Text {
            id: textGame
            y: -canvas.height
            font.pixelSize: 3 * gameOverRectangle.height / 7
            font.bold: true
            font.italic: true
            text: "Game"
            color: "white"

            states: State {
                name: "gameover"; when: (! bbb.running && ! aaa.running)
                PropertyChanges { target: textGame; y: 0; }
            }

            transitions: Transition {
                NumberAnimation { properties: "y"; easing.type: Easing.OutBounce; duration: 600 }
            }
        }

        Text {
            id: textOver
            x: -canvas.width - parent.x
            font.pixelSize: 3 * gameOverRectangle.height / 7
            font.bold: true
            font.italic: true
            text: "Over"
            color: "white"

            states: State {
                name: "gameover"; when: (! aaa.running)
                PropertyChanges { target: textOver; x: textGame.width + parent.wordSpacing; }
            }

            transitions: Transition {
                id: bbb
                NumberAnimation { properties: "x"; easing.type: Easing.OutElastic; duration: 900 }
            }
        }
    }

    onWidthChanged: {
        widthResolution = width
    }

    onHeightChanged: {
        heightResolution = height
    }

    Rectangle {
        id: optionsMenu

        y: -canvas.height
        width: gameField.width
        height: canvas.height
        anchors.horizontalCenter: canvas.horizontalCenter
        color: "lightyellow"

        Column {
            anchors.centerIn: optionsMenu

            Row {
                height: optionsMenu.height / 16
                spacing: height / 3

                CheckSquare {
                    id: gridCheckSquare
                }

                Text {
                    font.pixelSize: parent.height
                    color: "darkblue"
                    text: "Grid"
                }
            }
        }

        MenuButton {
            anchors.bottom: optionsMenu.bottom
            anchors.right: optionsMenu.right
            anchors.margins: optionsMenu.height / 30
            width: optionsMenu.height / 10
            height: width
            caption.text: "✔"

            mouseArea.onClicked: {
                optionsMenu.state = ""
            }
        }

        states: State {
            name: "active"
            PropertyChanges { target: optionsMenu; y: 0 }
            PropertyChanges { target: statusBar; enabled: false }
        }

        transitions: Transition {
            NumberAnimation { properties: "y"; easing.type: Easing.Linear; duration: 300}
        }
    }
}

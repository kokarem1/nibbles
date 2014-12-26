import QtQuick 2.0
import "GameEngine.js" as GameEngine

Rectangle {

    //property int horizontalCellsCount: 10 // Not correct, ...
    //property int verticalCellsCount: 10   // ... should be set in Haskell code // Something bad if 10:100 statusBar text

    property int widthResolution: 600
    property int heightResolution: 600

    property int scoreValue: 0
    property int speedValue: 3
    property int newSpeedValue: speedValue

    property string scoreText: "Score: " + scoreValue
    property string speedText: "Speed: " + speedValue
    property string newSpeedText: "Speed: " + newSpeedValue

    property bool splashScreen: true

    function incScore()
    {
        scoreValue += GameEngine.SCORE_SHIFT
    }

    function changeSpeed(isInc)
    {
        if (isInc && newSpeedValue < 10)
            ++newSpeedValue;
        else if ( ! isInc && newSpeedValue > 1)
            --newSpeedValue;
    }

    function initNewGame()
    {
        speedValue = newSpeedValue
        GameEngine.gameOverState = false
        GameEngine.nextGrowing = false
        GameEngine.game = createGame()
        gameTimer.restart()
        splashScreen = false
        statusBarRow.state = ""
        gameOverRectangle.state = ""
        scoreValue = 0
        scoreCaptionSB.visible = true
        speedCaptionSB.visible = true
        spacerRect.visible = true
        newGameButton.visible = false
        upDownButtons.visible = false
        newSpeedCaptionSB.visible = false
        settingsButton.visible = false
        statusBarRow.spacing = statusBar.width / 8
    }

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
                            if (value == 0)
                                "sandybrown"
                            else if (value == 1)
                                "yellow"
                            else if (value == 2)
                                "green"
                            else if (value == 3)
                                "red"
                            else if (value == -2) // GameOver effect
                                "darkred"
                            else if (value == -1) // Error
                                "white"

                        border.width: gridCheckSquare.checked? 1: 0
                    }
                }

                ListModel {id: listModel}

                Component.onCompleted: {
                    for (var i = 0; i < verticalCellsCount; ++i)
                        for (var j = 0; j < horizontalCellsCount; ++j)
                            listModel.append( { row: i, column: j, value: 0 } )
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
                spacing: statusOpacityTransition.running && ! splashScreen? statusBar.width / 8: statusBar.width / 20

                Text {
                    id: scoreCaptionSB

                    text: scoreText
                    font.pixelSize: statusBar.width / 20
                    font.bold: true
                    visible: statusOpacityTransition.running && ! splashScreen
                }

                Rectangle {
                    id: spacerRect

                    width: (3/5) * statusBar.height
                    height: width
                    visible: statusOpacityTransition.running && ! splashScreen
                    border.width: 1
                    color: "sandybrown"
                }

                Text {
                    id: speedCaptionSB

                    text: speedText
                    font.pixelSize: statusBar.width / 20
                    visible: statusOpacityTransition.running && ! splashScreen
                }

                Text {
                    id: newSpeedCaptionSB

                    text: newSpeedText
                    font.pixelSize: statusBar.width / 20
                    visible: ! statusOpacityTransition.running
                }

                Rectangle {
                    id: upDownButtons

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
                            changeSpeed(true)
                        }
                    }

                    StatusBarButton {
                        width: parent.width
                        height: (4/9) * parent.height
                        anchors.bottom: parent.bottom
                        caption.text: "▼"

                        mouseArea.onClicked: {
                            changeSpeed(false)
                        }
                    }
                }

                StatusBarButton {
                    id: newGameButton

                    width: statusBar.width / 4
                    height: (2/3) * statusBar.height

                    caption.text: "New Game"
                    visible: ! statusOpacityTransition.running || splashScreen

                    mouseArea.onClicked: {
                        initNewGame()
                    }
                }

                StatusBarButton {
                    id: settingsButton

                    height: (2/3) * statusBar.height
                    width: height
                    caption.text: "⚙"
                    visible: ! statusOpacityTransition.running || splashScreen

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

                    to: "gameover"

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

            to: "gameover"

            NumberAnimation { properties: "x"; easing.type: Easing.InCubic; duration: 500 }
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
            font.pixelSize: 3 * gameOverRectangle.height / 8
            font.bold: true
            font.italic: true
            text: "Game"
            color: "white"

            states: State {
                name: "gameover"; when: (! bbb.running && ! aaa.running)
                PropertyChanges { target: textGame; y: 0; }
            }

            transitions: Transition {
                to: "gameover"

                NumberAnimation { properties: "y"; easing.type: Easing.OutBounce; duration: 600 }
            }
        }

        Text {
            id: textOver
            x: -canvas.width - parent.x
            font.pixelSize: 3 * gameOverRectangle.height / 8
            font.bold: true
            font.italic: true
            text: "Over"
            color: "white"

            states: State {
                name: "gameover"; when: (! aaa.running && GameEngine.gameOverState) && ! splashScreen
                PropertyChanges { target: textOver; x: textGame.width + parent.wordSpacing; }
            }

            transitions: Transition {
                id: bbb

                to: "gameover"

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
            spacing: optionsMenu.height / 26

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

            Row {
                height: optionsMenu.height / 16
                spacing: height / 3

                CheckSquare {
                    id: twoKeysCheckSquare

                    checked: false
                }

                Text {
                    font.pixelSize: parent.height
                    color: "darkblue"
                    text: "2-keys control"
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

    property bool isPres: false

    Keys.onPressed: {
        if (GameEngine.gameOverState)
            return
        if ( ! isPres)
        {
            var moveRight = event.key == Qt.Key_Right || event.key == Qt.Key_D;
            var moveLeft = event.key == Qt.Key_Left || event.key == Qt.Key_A;
            var moveUp = event.key == Qt.Key_Up || event.key == Qt.Key_W;
            var moveDown = event.key == Qt.Key_Down || event.key == Qt.Key_S;

            var choice;
            if ( ! twoKeysCheckSquare.checked)
            {
                if (moveRight)
                    choice = 2
                else if (moveLeft)
                    choice = 4
                else if (moveUp)
                    choice = 1
                else if (moveDown)
                    choice = 3
            }
            else
            {
                if (moveRight)
                    choice = 1
                else if (moveLeft)
                    choice = 2
            }

            GameEngine.changeGameState(choice, twoKeysCheckSquare.checked)
        }
        isPres = true
    }

    Timer {
        id: gameTimer

        interval: newSpeedValue * 100
        running: false
        repeat: true

        onTriggered: {
            if ( ! isPres)
                GameEngine.changeGameState(0, twoKeysCheckSquare.checked)
            isPres = false
            if (GameEngine.gameOverState)
            {
                gameOverFunc()
                return
            }
            if (GameEngine.nextGrowing)
                incScore()
            for (var i = 0; i < verticalCellsCount * horizontalCellsCount; ++i)
                listModel.get(i).value = GameEngine.game.field[i]
            if (GameEngine.game.apple() != -1)
                listModel.get( GameEngine.game.apple() ).value = 3
            listModel.get( GameEngine.game.head() ).value = 1
        }
    }

    function gameOverFunc()
    {
        gameTimer.stop()
        listModel.set( GameEngine.game.head(), {value: -2} )
        statusBarRow.state = "gameover"
        gameOverRectangle.state = "gameover"

        scoreCaptionSB.visible = false
        speedCaptionSB.visible = false
        spacerRect.visible = false
        newGameButton.visible = true
        upDownButtons.visible = true
        newSpeedCaptionSB.visible = true
        settingsButton.visible = true
        statusBarRow.spacing = statusBar.width / 20
    }
}

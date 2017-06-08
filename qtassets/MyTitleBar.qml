import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

BorderImage {
    id: titleBar
    property alias text: textLabel.text
    property bool overFlowButtonVisible: true
    border.bottom: 0
    source: "images/toolbar.png"
    width: parent.width
    height: ui.titleBarHeight

    Rectangle {
        id: backButton
        anchors.left: parent.left
        anchors.leftMargin: ui.defautMargin
        opacity: stackView.depth > 1 ? 1 : 0
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        height: textLabel.height
        width: opacity ? height : 0
        radius: ui.defautButtonRadius
        color: backmouse.pressed ? "#222" : "transparent"

        Behavior on opacity { NumberAnimation{} }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: "images/navigation_previous_item.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            asynchronous: false
            cache: false
        }

        MouseArea {
            id: backmouse
            anchors.fill: parent
            anchors.margins: -(ui.defautMargin/2)

            onClicked: stackView.pop()
        }
    }

    MyLabel {
        id: textLabel
        font.pixelSize: ui.titleBarFontSize
        font.bold: true
        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
        x: backButton.x + backButton.width + ui.defautMargin
        anchors.verticalCenter: parent.verticalCenter
        color: "#f0f0f0"
    }

    Image {
        id: overflowButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        source: "images/overflow_action.png"
        visible: titleBar.overFlowButtonVisible && !ui.isDesktop
    }

    /*
    Example, how we can move root borderless window
    MouseArea {
        anchors.fill: parent;
        property variant clickPos: "1,1"

        onPressed: {
            clickPos  = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            appWindow.x += delta.x;
            appWindow.y += delta.y;
        }
    }
    */
}

import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Rectangle {
    id: spaceInfoComponent
    width: parent.width
    height: 2 * ui.defautColumnSpacing + header.height + label.height + progressBar.height + border.width*2 + 2*radius
    color: "transparent"
    radius: ui.defaultRectangleRadius

    property alias headerTitle:  header.title
    property alias headerSubTitle:  header.subTitle
    property alias text:  label.text
    property alias progress: progressBar.value
    property int userData: 0
    signal clicked(string data)

    Column {
        id: spaceInfoColumn
        width: parent.width - 2 * spaceInfoComponent.radius
        spacing: ui.defautColumnSpacing
        anchors.centerIn: parent

        MyHeader {
            id: header
            width: parent.width
            fontSize: ui.largeFontSize
            textColor: "white"
        }

        MyLabel {
            id: label
            width: parent.width
            color: "grey"
        }

        MyProgressBar {
            id: progressBar
            width: parent.width
        }
    }

    MouseArea {
        anchors.fill: parent

        function restoreArea() {
            spaceInfoComponent.color = "transparent"
        }

        onClicked: {
            restoreArea()
            spaceInfoComponent.clicked(spaceInfoComponent.userData)
        }

        onEntered: {
            spaceInfoComponent.color = "#093547"
        }

        onReleased: {
            restoreArea()
        }

        onCanceled: {
            restoreArea()
        }

        onExited: {
            restoreArea()
        }
    }
}

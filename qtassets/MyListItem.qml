import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Item {
    id: root
    width: parent.width
    height: ui.listViewItemHeight

    property alias text: textItem.text
    property alias status: statusTextItem.text
    property alias description: descriptionTextItem.text
    property alias imageSource: image.source
    property alias imageVisible: image.visible

    property bool itemSelectionEnabled: true
    property bool selectionAtMousePress: true // or selection at mouse click
    property bool selected: false
    property bool multiSelectionMode: false

    property string fileNamePathValue

    signal clicked
    signal pressAndHold

    Component.onCompleted: {
        if (myApp.isDesktop()) {
            textItem.anchors.leftMargin = ui.listViewItemMargin
            rectangle.anchors.margins = ui.listViewItemMargin/2
        }
    }

    // background color, state when an item was pressed
    Rectangle {
        id: backgroundRectangle
        anchors.fill: parent
        color:  "#093547"
        visible: multiSelectionMode ? selected : (selectionAtMousePress ? (mouse.pressed && itemSelectionEnabled) : (selected && selectionAtMousePress))
    }

    // Feature image
    Image {
        id: image
        visible: false
        asynchronous: true
        cache: true
        width: (visible) ? (root.height - ui.listViewItemMargin ): 0
        height: (visible) ? (root.height - ui.listViewItemMargin) : 0
        anchors.left: parent.left
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
    }

    Column {
        id: column
        anchors.fill: parent
        spacing: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: (image.visible ) ? (image.width + image.width/(ui.listViewItemMargin/2)) : ui.listViewItemMargin

        Row {
            id: row1
            width: parent.width
            height: row2.visible ? (parent.height * 66/ 100) : parent.height

            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"

                // Main text
                MyLabel {
                    id: textItem
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#f0f0f0"
                    width:  statusTextItem.visible ? (parent.width - statusTextItem.width - 2 * ui.listViewItemMargin) : (parent.width)
                }

                // Status text
                MyLabel {
                    id: statusTextItem
                    anchors.verticalCenter: parent.verticalCenter
                    color: "grey"
                    anchors.right: parent.right
                    visible: (text.length > 0) ? true : false
                }
            }
        }

        Row {
            id: row2
            visible: descriptionTextItem.text.length > 0
            width: parent.width
            height: parent.height - row1.height

            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"
                MyLabel  {
                    id: descriptionTextItem
                    color: "grey"
                    width: textItem.width
                    font.pixelSize: textItem.font.pixelSize/1.375
                }
            }
        }
    }

    // Border
    Rectangle {
        id: rectangle
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: ui.listViewItemMargin
        height: ui.listViewItemBorderHeight
        color: "#424246"
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {
            if (ui.isDesktop) {
                if ((mouse.button == Qt.RightButton)) {
                    root.pressAndHold()
                    return
                }
            }
            if (!root.selectionAtMousePress) {
                root.selected = !root.selected
            }

            fileItemModel.toggleSelection(fileNamePathValue,root.selected)
            root.clicked()
        }

        onPressAndHold: {
            if (ui.isDesktop) {
                return
            }
            root.pressAndHold()
        }
    }
}

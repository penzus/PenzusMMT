import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Row {
    id: row
    width: parent.width
    height: ui.listViewItemHeight * 3.5
    spacing: ui.defautColumnSpacing

    property alias text1: label1.text
    property alias text2: label2.text
    property alias text3: label3.text
    property alias imageSource: image.source

    Image {
        id: image
        fillMode: Image.PreserveAspectFit
        height: parent.height
        width: height/1.333
    }

    Column {
        width: row.width - image.width - row.spacing
        anchors.verticalCenter: parent.verticalCenter
        MyLabel {
            id: label1
            font.bold: true
            width: parent.width
        }
        MyLabel {
            id: label2
            width: parent.width
        }
        MyLabel {
            id: label3
            width: parent.width
        }
    }
}

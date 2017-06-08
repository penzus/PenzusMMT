import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."


Column {
    id: column
    width: parent.width
    spacing: ui.defautColumnSpacing

    property alias text1: label1.text
    property alias text2: label2.text
    property alias text3: label3.text
    property alias text4: label4.text

    MyLabel {
        id: label1
        width: parent.width
    }
    MyLabel {
        id: label2
        width: parent.width
    }
    Row {
        width: parent.width
        MyLabel {
            id: label3
        }
        MyLabel {
            id: labelEmpty
            text: " "
        }
        MyLabel {
            id: label4
        }
    }
}

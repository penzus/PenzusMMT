import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Row {
    id: row
    width: parent.width
    property alias color: rect.color

    Rectangle {
        id: rect
        width: row.width
        height: ui.defautSpacerHeight
        color : "transparent"
    }
}

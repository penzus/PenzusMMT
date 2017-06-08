import QtQuick 2.6
import QtQuick.Controls 1.4
// Needed for singletons QTBUG-34418
import "."

Row {
    id: row
    spacing: ui.defautRowSpacing
    width: parent.width

    property alias text: label.text
    property alias checked: checkBox.checked

    MyLabel {
        id: label
        anchors.verticalCenter: row.verticalCenter
        width: parent.width - checkBox.width - row.spacing
    }

    CheckBox {
        id: checkBox
        anchors.verticalCenter: row.verticalCenter
    }
}

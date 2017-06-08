import QtQuick 2.6

Row {
    id: row
    width: parent.width
    property alias text: label.text
    property alias text2: extField.text
    property bool multiline: true

    MyLabel {
        id: label
        width: row.width/3
        text: "-"
    }

    MyLabel {
        id: extField
        maximumLineCount:  row.multiline ? 10 : 1
        elide: row.multiline ? Text.ElideNone : Text.ElideRight
        wrapMode: row.multiline ? Text.Wrap : Text.NoWrap
        width: row.width - label.width
        text: "-"
    }
}

import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Row {
    id: header
    property alias title: label.text
    property alias subTitle: label2.text
    property int fontSize: ui.smallFontSize
    property string textColor: "#969696"

    width: parent.width

    Column {
        spacing: ui.defaultHeaderSpacing

        Row {
            spacing: ui.defaultHeaderSpacing

            MyLabel {
                property int leftMargin: ui.defautMargin
                id: label
                color: header.textColor
                width: header.width - leftMargin - ((label2.visible) ? (label2.width - ui.defaultHeaderSpacing) : 0)
                font.pixelSize: header.fontSize
                x: parent.x + leftMargin
            }

            MyLabel {
                id: label2
                visible: (text.length > 0)
                color: header.textColor
                font.pixelSize: header.fontSize
            }
        }

        Rectangle {
            width: header.width
            height: ui.defaultHeaderBorderHeight
            color : "#262626"
        }
    }
}

import QtQuick 2.6
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
// Needed for singletons QTBUG-34418
import "."

ProgressBar {
    id: imageView
    width: parent.width
    minimumValue: 0
    maximumValue: 100
    value: 65

    style: ProgressBarStyle {
        background: Rectangle {
            radius: ui.defaultRectangleRadius / 2
            color: "#282828"
            border.color: "gray"
            border.width: 0
            implicitWidth: spaceInfoContainer.width
            implicitHeight: ui.defaultHeaderBorderHeight * 2
        }

        progress: Rectangle {
            color: "#0091cb"
            border.color: "steelblue"
        }
    }
}

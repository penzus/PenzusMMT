import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
// Needed for singletons QTBUG-34418
import "."

Item {
    id: featureButton
    width: 230
    height: 160

    property alias text: textLabel.text

    signal clicked()

    function updateUi() {
        if (ui.isDesktop) {
            return
        }
        var minSize = Math.min(Screen.width, Screen.height)
        width = (minSize - ui.defautMargin*2)/2
        height = width * 0.62
    }

    Screen.onPrimaryOrientationChanged: {
        updateUi()
    }

    Component.onCompleted: {
        updateUi()
    }

    Item {
        id: centerItem
        width: featureButton.width - ui.defautMargin/2
        height: featureButton.height - ui.defautMargin/2
        anchors.centerIn: parent

        Rectangle {
            id: rectangle
            visible: true
            width: centerItem.width
            height: centerItem.height
            color: ui.featureColor1
            radius: ui.defaultRectangleRadius * 2
        }

        MyLabel {
            id: textLabel
            width: centerItem.width
            height: centerItem.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: ui.isDesktop ? ui.titleBarFontSize : ui.xLargeFontSize
            color: "black"
        }

        MouseArea {
            anchors.fill: centerItem

            function restoreImageOpacity() {
                rectangle.opacity = 1.0
            }

            onEntered: {
                rectangle.opacity = 0.8
            }

            onReleased: {
                restoreImageOpacity()
            }

            onCanceled: {
                restoreImageOpacity()
            }

            onExited: {
                restoreImageOpacity()
            }

            onClicked: {
                restoreImageOpacity()
                featureButton.clicked()
            }
        }
    }
}

import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
// Needed for singletons QTBUG-34418
import "."

Rectangle {
    id: button
    width: ui.defautImageButtonWidth
    height: ui.defautImageButtonHeight
    radius: ui.defautImageButtonRadius

    property string text
    property alias imageSource: image.source
    property bool enabled: true
    property bool pressed: false

    signal clicked()

    gradient: Gradient {
        GradientStop {
            position: 0;
            color: {
                if (!button.enabled) return "#1f1f1f"
                return button.pressed ? "#505050" : "#313131"
            }
        }

        GradientStop {
            position: 1;
            color: {
                if (!button.enabled) return "#191919"
                return button.pressed ? "#474747" : "#282828"
            }
        }
    }

    Image {
        id: image
        source: "qrc:/qtassets/images/info.png"
        anchors.centerIn: button.Center
        opacity: button.enabled ? 1.0 : 0.5
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        asynchronous: false
        cache: false
    }

    MouseArea {
        anchors.fill: parent

        onEntered: {
            if (!button.enabled) {
                return
            }
            button.pressed = true
        }

        onReleased: {
            if (!button.enabled) {
                return
            }
            button.pressed = false
        }

        onCanceled: {
            if (!button.enabled) {
                return
            }
            button.pressed = false
        }

        onExited: {
            if (!button.enabled) {
                return
            }
            button.pressed = false
        }

        onClicked: {
            if (!button.enabled) {
                return
            }
            button.pressed = false
            button.clicked()
        }
    }
}

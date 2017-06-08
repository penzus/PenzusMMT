import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Rectangle {
    id: dialogButton
    width: parent.width
    color: ui.dialogBackgroundButtonColor
    height: buttonSpacer1.height + titleLabel.height + buttonSpacer2.height + 2 * ui.defautColumnSpacing

    property alias text: titleLabel.text
    property bool entered: false
    property bool enabled: true

    signal clicked()

    Column {
        spacing: ui.defautColumnSpacing
        width: parent.width

        MySpacer {
            id: buttonSpacer1
            color: ui.dialogBackgroundButtonColor
        }

        MyLabel{
            id: titleLabel
            text: "Button text"
            color: dialogButton.enabled ? ui.dialogFontColor : ui.dialogDisabledButtonFontColor
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MySpacer {
            id: buttonSpacer2
            color: ui.dialogBackgroundButtonColor
        }

    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        function restoreArea() {
            dialogButton.color = ui.dialogBackgroundButtonColor
            buttonSpacer1.color = ui.dialogBackgroundButtonColor
            buttonSpacer2.color = ui.dialogBackgroundButtonColor
            dialogButton.entered = false
        }

        onClicked: {
            restoreArea()
            dialogButton.clicked()
        }

        onEntered: {
            dialogButton.entered = true
            dialogButton.color = ui.dialogBackgroundPressedButtonColor
            buttonSpacer1.color = ui.dialogBackgroundPressedButtonColor
            buttonSpacer2.color = ui.dialogBackgroundPressedButtonColor
        }

        onReleased: {
            restoreArea()
        }

        onCanceled: {
            restoreArea()
        }

        onExited: {
            restoreArea()
        }
    }
}

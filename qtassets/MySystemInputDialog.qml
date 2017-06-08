import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
// Needed for singletons QTBUG-34418
import "."

AbstractDialog {
    id: systemInputDialog

    property alias title: titleLabel.text
    property alias body: bodyLabel.text
    property alias text: textField.text
    property alias confirmButtonText: okButton.text
    property alias cancelButtonText: cancelButton.text

    function show() {
        systemInputDialog.visible = true
        textField.startTimer()
    }

    contentItem: Item {
        id: rootItem
        z: 1
        implicitWidth: ui.defaultDialogWidth
        anchors.centerIn: parent

        Keys.onEnterPressed: systemInputDialog.accept()
        Keys.onEscapePressed: systemInputDialog.reject()
        //Keys.onBackPressed: filledDialog.reject() // especially necessary on Android

        Component.onCompleted: {
            rootItem.height = column.height
            rootItem.implicitHeight = rootItem.height
        }

        Rectangle {
            id: rect
            anchors.fill: parent
            radius: ui.defaultRectangleRadius
            color:  ui.dialogBackgroundButtonColor

            Rectangle {
                id: whiteRectangle
                radius: ui.defaultRectangleRadius
                color: "white"
                width: parent.width
                height: rect.height - buttonRow.height
            }

            Rectangle {
                id: whiteRectangle2
                color: whiteRectangle.color
                width: parent.width
                height: spacer1.height
                y: whiteRectangle.y + whiteRectangle.height - spacer1.height
            }

            Column {
                id: column
                spacing: ui.defautColumnSpacing
                anchors.leftMargin: ui.defautMargin
                width: rootItem.width - 2 * anchors.leftMargin
                anchors.left: parent.left

                MySpacer {
                    id: spacer1
                }

                MyLabel{
                    id: titleLabel
                    text: "Enter a new file name"
                    color: ui.dialogFontColor
                    font.bold: true
                    width: column.width
                }

                MyLabel {
                    id: bodyLabel
                    color: ui.dialogFontColor
                    text: " "

                }

                TextField  {
                    id: textField
                    width: column.width
                    placeholderText: ""
                    selectByMouse: true

                    function isValidData() {
                        if (!visible) {
                            return
                        }
                        return (!mml.stringIsEmpty(textField.text))
                    }

                    function startTimer() {
                        timer.start()
                    }

                    Timer {
                        id: timer
                        repeat: true
                        interval: 250

                        onTriggered : {
                            if (!textField.visible) {
                                return
                            }
                            okButton.enabled = textField.isValidData()
                        }
                    }
                }

                Row {
                    id: buttonRow
                    spacing: 0

                    MyDialogButton {
                        id: cancelButton
                        text: qsTr("Cancel")
                        width: column.width/2 - verticalDivider.width/2

                        onClicked: {
                            systemInputDialog.reject()
                        }
                    }

                    MyVerticalDivider {
                        id: verticalDivider
                        width: ui.defautDividerWidtht
                        color: ui.dialogDividerColor
                    }

                    MyDialogButton {
                        id: okButton
                        text: qsTr("OK")
                        enabled: false
                        width: column.width/2 - verticalDivider.width/2

                        onClicked: {
                            if (textField.isValidData()) {
                                systemInputDialog.accept()
                            }
                        }
                    }
                }
            }

            Rectangle {
                anchors.left: rect.left
                y: buttonRow.y
                width: column.anchors.leftMargin
                height: buttonRow.height
                radius: rect.radius
                color:  (cancelButton.entered) ? ui.dialogBackgroundPressedButtonColor : ui.dialogBackgroundButtonColor
            }

            Rectangle {
                anchors.right: rect.right
                y: buttonRow.y
                width: column.anchors.leftMargin
                height: buttonRow.height
                radius: rect.radius
                color:  (okButton.entered) ? ui.dialogBackgroundPressedButtonColor : ui.dialogBackgroundButtonColor
            }

            MyHorizontalDivider {
                id: horizontalDivider
                color: ui.dialogDividerColor
                y: buttonRow.y
            }
        }
    }
}

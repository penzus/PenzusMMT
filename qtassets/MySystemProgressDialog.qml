import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
// Needed for singletons QTBUG-34418
import "."

AbstractDialog {
    id: systemProgressDialog

    property alias title: titleLabel.text
    property alias body: bodyLabel.text
    property alias statusMessage: statusLabel.text
    property alias progress: progressBar.value
    property alias activityIndicatorVisible: busyIndicator.running
    property alias cancelButtonText: button.text

    function show() {
        systemProgressDialog.visible = true
    }

    signal finished()

    contentItem: Item {
        id: rootItem
        z: 1
        implicitWidth: ui.defaultDialogWidth
        anchors.centerIn: parent

        Keys.onEnterPressed: systemProgressDialog.accept()
        Keys.onEscapePressed: systemProgressDialog.reject()

        Component.onCompleted: {
            rootItem.height = column.height
            rootItem.implicitHeight = rootItem.height
        }

        Rectangle {
            id: rect
            anchors.fill: parent
            radius: ui.defaultRectangleRadius
            color: button.entered ?  ui.dialogBackgroundPressedButtonColor : ui.dialogBackgroundButtonColor

            Rectangle {
                id: whiteRectangle
                radius: ui.defaultRectangleRadius
                color: "white"
                width: parent.width
                height: rect.height - button.height
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

                Row {
                    id: row

                    MyLabel{
                        id: titleLabel
                        text: "Operation in progress"
                        color: ui.dialogFontColor
                        font.bold: true
                        width: column.width  - busyIndicator.width
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    BusyIndicator {
                        id: busyIndicator
                        running: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MyLabel {
                    id: bodyLabel
                    color: ui.dialogFontColor
                    text: "Please, wait..."

                }

                ProgressBar {
                    id: progressBar
                    value: 50
                    minimumValue: 0
                    maximumValue: 100
                    width: column.width
                }

                MyLabel {
                    id: statusLabel
                    color: ui.dialogFontColor
                    text: "50%"
                }

                MyDialogButton {
                    id: button
                    width: column.width
                    anchors.horizontalCenter: column.horizontalCenter

                    onClicked: {
                        systemProgressDialog.accept()
                        systemProgressDialog.finished()
                    }
                }
            }

            MyHorizontalDivider {
                id: horizontalDivider
                color: ui.dialogDividerColor
                width: rect.width
                y: button.y
            }
        }
    }
}

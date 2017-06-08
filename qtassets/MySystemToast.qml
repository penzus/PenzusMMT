import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Rectangle {
    id: toastMessageRoot
    anchors.fill: parent
    visible: false
    color: "transparent"
    property alias body:  messageText.text
    z: 99

    MouseArea {
        anchors.fill: parent
        onClicked: {
            toastMessageRoot.cancel()
        }
    }

    function displayMessage(message) {
        if (!ui.isDesktop) {
            systemTools.showSystemToast(message)
            return
        }

        toastMessage.height = 100
        messageText.textInitialized = false
        messageText.text = message
        toastMessageRoot.visible = true
        toastMessage.height = column.height + 2 * column.spacing
        timer.start()
    }

    function cancel () {
        toastMessageRoot.visible = false
    }

    Rectangle {
        id: toastMessage
        anchors.centerIn: parent
        width: ui.defaultDialogWidth
        height: 100
        z: 100
        color: "#262626"
        radius: ui.defaultRectangleRadius
        border.color: "#191919"

        Column {
            id: column
            spacing: ui.defautColumnSpacing
            anchors.leftMargin: ui.defautMargin
            width: toastMessage.width
            height: spacer1.height + spacer2.height + messageText.height
            anchors.left: parent.left

            MySpacer {
                id: spacer1
            }

            MyLabel {
                id: messageText
                wrapMode: Text.WordWrap
                maximumLineCount: 5
                anchors.horizontalCenter: parent.horizontalCenter
                property bool textInitialized: false

                function updateGui() {
                    if ( (contentWidth >= (parent.width - 2 * column.spacing ) ) ) {
                        width = column.width - 2 * column.spacin
                    } else {
                        if (textInitialized) {
                            width = contentWidth
                        }
                    }
                    textInitialized = true
                }

                onTextChanged: {
                    updateGui()
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        appWindow.showInfoDialog(templates.currentTemplate, titleLabel.text)
                    }
                }
            }

            MySpacer {
                id: spacer2
            }
        }

        Timer {
            id: timer
            interval: 2500

            onTriggered: {
                toastMessageRoot.cancel()
            }
        }
    }
}

import QtQuick 2.6
import QtQuick.Dialogs 1.2
// Needed for singletons QTBUG-34418
import "."

Item {
    id: topLevelItem
    objectName: "AboutPage"
    width: parent.width
    height: parent.height

    property string title: qsTr("About")

    function updateGui() {
        if (visible) {
            appWindow.showAppMenu(false)

            var index = 0

            appWindow.setContextMenuItemState(index,true,true)
            appWindow.setContextMenuItemText(index++,qsTr("Release info"))

            appWindow.setContextMenuItemState(index,true,true)
            appWindow.setContextMenuItemText(index++,qsTr("Acknowledgment"))

            appWindow.setContextMenuItemState(index,true,true)
            appWindow.setContextMenuItemText(index++,qsTr("Libraries"))

            appWindow.setContextMenuItemState(index,true,true)
            appWindow.setContextMenuItemText(index++,qsTr("Privacy policy"))

            appWindow.setContextMenuItemState(index,true,true)
            appWindow.setContextMenuItemText(index++,qsTr("Feedback"))

            if (!ui.isDesktop) {
                appWindow.setContextMenuItemState(index,true,true)
                appWindow.setContextMenuItemText(index++,qsTr("Inspire us"))
            }

            appWindow.changeTitle(title)
        }
    }

    function customMenuItemClicked(index) {
        switch (index) {
        case 0:
            showReleaseInfoDialog()
            return
        case 1:
            appWindow.gotoPage("AcknowledgmentPage.qml")
            return
        case 2:
            appWindow.gotoPage("LibrariesPage.qml")
            return
        case 3:
            Qt.openUrlExternally("http://www.penzus.com/privacypolicy.html")
            return
        case 4:
            Qt.openUrlExternally(myApp.officialEMailLink(false))
            return
        case 5:
            showInspireUsDialog()
            return
        default:
            ;
        }
    }

    onVisibleChanged: {
        updateGui()
    }

    Component.onCompleted: {
        updateGui()
    }

    Component.onDestruction: {
        appWindow.popTransitionEnded(objectName)
    }

    Rectangle {
        id: topLevelItemRect
        width:  parent.width
        height: parent.height
        color: "transparent"

        Rectangle {
            id: rect
            width: topLevelItem.width
            height: topLevelItem.height
            color : "transparent"
        }
        Column {
            spacing: ui.defautColumnSpacing
            anchors.centerIn: rect

            MyLabel {
                id: labelAppName
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: ui.isDesktop ? ui.titleBarFontSize : ui.xLargeFontSize
                font.bold: true
                text: myApp.officialAppName()
            }

            MyLabel {
                anchors.horizontalCenter: parent.horizontalCenter
                text: myApp.officialAppDescription()
            }
            MyLabel {
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    qsTr("Version")  + " " + myApp.versionNumber()
                }
            }
            MyLabel {
                anchors.horizontalCenter: parent.horizontalCenter
                text: myApp.officialUrlLink()
            }
            MyLabel {
                anchors.horizontalCenter: parent.horizontalCenter
                text: myApp.officialEMailLink()
            }
        }
    }

    function showReleaseInfoDialog() {
        messageDialog.title = qsTr("Release info")
        messageDialog.text = myApp.buildInfo()
        messageDialog.standardButtons = StandardButton.Close
        messageDialog.open()
    }

    function showInspireUsDialog() {
        messageDialog.title = qsTr("Inspire us")
        messageDialog.text = qsTr("Love using Penzus MMT? Rate us on Google Play to keep us inspired! For suggestions and feedbacks, write us via Feedback.")
        messageDialog.standardButtons = StandardButton.Ok | StandardButton.Cancel
        messageDialog.open()
    }

    MessageDialog {
        id: messageDialog
        onAccepted: {
            Qt.openUrlExternally(myApp.officialMarketLink(false))
        }
    }
}

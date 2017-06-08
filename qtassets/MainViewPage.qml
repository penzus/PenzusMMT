import QtQuick.Layouts 1.3
import QtQuick 2.6

Item {
    objectName: "MainViewPage"
    width: parent.width
    height: parent.height

    function updateGui() {
        if (visible) {
            appWindow.changeTitle(myApp.officialAppName())
            appWindow.showAppMenu(true)
        }
    }

    onVisibleChanged: {
        updateGui()
    }

    Component.onCompleted: {
        updateGui()
    }

    Column {
        anchors.centerIn: parent

        Row {
            MyFeatureButton {
                text: qsTr("Video")
                onClicked: {
                    appWindow.invokeMainPage(1,text)
                }
            }

            MyFeatureButton {
                text: qsTr("Audio")
                onClicked: {
                    appWindow.invokeMainPage(2,text)
                }
            }
        }

        Row {

            MyFeatureButton {
                text: qsTr("Image")
                onClicked: {
                    appWindow.invokeMainPage(3,text)
                }
            }

            MyFeatureButton {
                text: qsTr("My files")
                onClicked: {
                    appWindow.hideAppMenu()
                    appWindow.gotoPage("FileManagerPage.qml")
                }
            }
        }
    }
}

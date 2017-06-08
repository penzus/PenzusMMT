import QtQuick 2.6
import QtQuick.Controls 1.4
// Needed for singletons QTBUG-34418
import "."

Item {
    id: backgroundRectangle
    objectName: "SettingsPage"
    width: parent.width
    height: parent.height

    property string title: qsTr("Settings")

    function updateGui() {
        if (visible) {
            appWindow.changeTitle(title)
        }
    }

    onVisibleChanged: {
        updateGui()
    }

    Component.onCompleted: {
        updateGui()
    }

    Rectangle {
        id: rect
        width: Math.min(backgroundRectangle.width, ui.maximumPageWidth)
        height: backgroundRectangle.height
        color : "transparent"
        anchors.centerIn: backgroundRectangle
    }

    Flickable {
        id: scrollView
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: rect
        clip: true
        contentWidth: column.width;
        contentHeight: column.height
        anchors.centerIn: rect

        Component.onCompleted:  {
            inputFileItem.absFileNamePath0 = settings.defaultOutputDir
            inputFileItem.update()
            playSoundWhenFinished.checked = settings.playSoundWhenFinished
            vibrateWhenFinished.checked = settings.vibrateWhenFinished
            fullScreenMode.checked = settings.fullScreenMode
        }

        Component.onDestruction:  {
            settings.defaultOutputDir = inputFileItem.absFileNamePath0
            settings.playSoundWhenFinished = playSoundWhenFinished.checked
            settings.vibrateWhenFinished = vibrateWhenFinished.checked
            settings.language = languageDropDown.getOptionByValue()
            settings.fullScreenMode = fullScreenMode.checked
            settings.style = styleDropDown.getOptionByValue()
            settings.save()
            appWindow.updateGui()
            appWindow.popTransitionEnded(backgroundRectangle.objectName)
        }

        Column {
            id: column
            spacing: ui.defautColumnSpacing
            width: rect.width - 2 * ui.defautMargin
            anchors.left: parent.left
            anchors.leftMargin: ui.defautMargin

            MySpacer {

            }

            InputItem {
                id: inputFileItem
                title: qsTr("Default output folder")
            }

            MyHeader {
                title:  qsTr("When operation is complete")
            }

            MyCheckBox {
                id: playSoundWhenFinished
                text: qsTr("Play system sound")
            }

            MyCheckBox {
                id: vibrateWhenFinished
                text: qsTr("Vibrate")
            }

            MyHeader {
                title: qsTr("User interface")
            }

            MyCheckBox {
                id: fullScreenMode
                visible: !ui.isDesktop
                text: qsTr("Fullscreen mode")
            }

            MyDropDown {
                id: styleDropDown
                visible: false
                title: qsTr("Style")

                onInitialized: {
                    appendOption ( "Android", "1" )
                    appendOption ( qsTr("Advanced"), "2" )
                    setOptionByValue (settings.style)
                }
            }

            MyDropDown {
                id: languageDropDown
                title: qsTr("Language (restart required)")

                onInitialized: {
                    appendOption( qsTr("System"), "" )
                    appendOption ( "English", "en_US" )
                    appendOption ( "Русский", "ru_RU" )
                    setOptionByValue (settings.language)
                }
            }

            MySpacer {

            }
        }
    }
}

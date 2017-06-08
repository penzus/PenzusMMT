import QtQuick.Dialogs 1.2
import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

AbstractDialog {
    id: dialog
    title: myApp.officialAppName()

    property string brandedColor: "#087098"

    contentItem: Rectangle {
        width: appWindow.width
        height: appWindow.height
        id: backgroundRectangle
        implicitWidth: appWindow.width
        implicitHeight: appWindow.height
        color : appWindow.appColor

        Rectangle {
            id: rect
            width: Math.min(backgroundRectangle.width, ui.maximumPageWidth)
            height: parent.height
            color : appWindow.appColor
            anchors.centerIn: backgroundRectangle
        }

        Rectangle {
            id: topLevelColumn
            color : appWindow.appColor
            anchors.fill: rect

            Rectangle {
                id: headerColumn
                color: dialog.brandedColor
                width: parent.width
                height: (spacer1.height + ui.defautColumnSpacing)* 4 + welcomeLabel.height

                Column {
                    spacing: ui.defautColumnSpacing
                    width: parent.width
                    height: (spacer1.height + ui.defautColumnSpacing)* 4 + welcomeLabel.height

                    MySpacer {
                        id: spacer1
                    }

                    MySpacer {

                    }

                    MyLabel {
                        id: welcomeLabel
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: ui.largeFontSize
                        font.bold: true
                        text: qsTr("Welcome!")
                    }

                    MySpacer {

                    }

                    MySpacer {

                    }
                }
            }

            Rectangle {
                anchors.top:  headerColumn.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: footerColumn.top
                color : appWindow.appColor
                width: parent.width

                Flickable {
                    id: flickable
                    flickableDirection: Flickable.VerticalFlick
                    anchors.fill: parent
                    clip: true
                    contentWidth: parent.width
                    contentHeight:  Math.max(dataContainer.height, parent.height)
                    boundsBehavior: Flickable.StopAtBounds

                    Rectangle {
                        id: dataContainer
                        width: parent.width - ui.defautMargin
                        height: textLabel.height
                        anchors.centerIn: parent
                        color : appWindow.appColor

                        MyLabel {
                            id: textLabel
                            width: parent.width
                            wrapMode: Text.WordWrap
                            maximumLineCount: -1
                            horizontalAlignment: Text.AlignJustify
                            text: qsTr("Thank you for downloading Penzus MMT! This is the first version of the app and we would like to draw your attention to the fact that it might contain some bugs, although it has undergone thorough testing. So, we encourage you to report the bugs you have found, as well as errors and your requests using the contact details provided in the About section. Also, we would like to stress that sometimes the operating system's in-built tools for audio/video playback have issues with some multimedia data. This is why to ensure the most comfortable playback we recommend you to use an audio/video player allowing for playback of multimedia files by means of not only hardware decoding, but software tools, too.")
                        }
                    }
                }
            }

            Rectangle {
                id: footerColumn
                color:  appWindow.appColor
                anchors.bottom: topLevelColumn.bottom
                width: parent.width
                height: ui.defautColumnSpacing * 2 + continueButton.height

                MyButton {
                    id: continueButton
                    text: qsTr("Continue")
                    anchors.centerIn: parent

                    onClicked: {
                        dialog.accept()
                    }
                }
            }
        }
    }
}

import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Item {
    id: backgroundRectangle
    objectName: "AcknowledgmentPage"
    width: parent.width
    height: parent.height
    property string title: qsTr("Acknowledgment")

    Component.onCompleted:  {
        appWindow.hideAppMenu()
        appWindow.changeTitle(title)
    }

    Rectangle {
        id: rect
        width: Math.min(backgroundRectangle.width, ui.maximumPageWidth)
        height: backgroundRectangle.height
        color : "transparent"
        anchors.centerIn: backgroundRectangle
    }

    Flickable {
        id: flickable
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: rect
        clip: true
        contentWidth: column.width;
        contentHeight: column.height
        anchors.centerIn: rect

        Column {
            id: column
            spacing: ui.defautColumnSpacing
            width: rect.width - 2 * ui.defautMargin
            anchors.left: parent.left
            anchors.leftMargin: ui.defautMargin

            MySpacer {

            }
            AcknowledgmentItem {
                imageSource: "qrc:/qtassets/images/featured/vernigorka.png"
                text1:  qsTr("Media support")
                text2:  "Vernigorka"
                text3:  myApp.createLinkFromData("mailto:vernigora@blackberrys.ru", "vernigora@blackberrys.ru")
            }

            MyHorizontalDivider {

            }
            AcknowledgmentItem {
                imageSource: "qrc:/qtassets/images/featured/yurchenko.png"
                text1:  qsTr("English language support")
                text2:  "Boris Yurchenko"
                text3:  myApp.createLinkFromData("boris@yurchenko.pp.ua", "boris@yurchenko.pp.ua")
            }
            MyHorizontalDivider {

            }
        }
    }
}

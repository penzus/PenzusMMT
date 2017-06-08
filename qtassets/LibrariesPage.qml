import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Item {
    id: backgroundRectangle
    objectName: "LibrariesPage"
    width: parent.width
    height: parent.height
    property string title: qsTr("Libraries")

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

            property string text1: qsTr("under the following license")

            MySpacer {

            }
            LibrariesItem {
                text1:  "Qt"
                text2: myApp.createLinkFromData("https://www.qt.io")
                text3:  column.text1
                text4:  myApp.createLinkFromData("http://www.gnu.org/licenses", "LGPL license")
            }

            MyHorizontalDivider {

            }
            LibrariesItem {
                text1:  "Oxygen Icons"
                text2: myApp.createLinkFromData("https://github.com/pasnox/oxygen-icons-png")
                text3:  column.text1
                text4:  myApp.createLinkFromData("http://www.gnu.org/licenses", "LGPL license")
            }

            MyHorizontalDivider {

            }
            LibrariesItem {
                text1:  "TagLib"
                text2: myApp.createLinkFromData("https://taglib.github.io")
                text3:  column.text1
                text4:  myApp.createLinkFromData("http://www.gnu.org/licenses", "LGPL license")
            }
            MyHorizontalDivider {

            }
            LibrariesItem {
                text1:  "LAME"
                text2: myApp.createLinkFromData("http://lame.sourceforge.net/")
                text3:  column.text1
                text4:  myApp.createLinkFromData("http://www.gnu.org/licenses", "LGPL license")
            }
            MyHorizontalDivider {

            }
        }
    }
}

import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Column {
    id: imageInfoContainer
    spacing: ui.defautColumnSpacing
    function initialize(fileNamePath) {
        imageView.source = fileUtils.pathToUrl(fileNamePath)
        imageResolutionInfoItem.text2 = properties.imageWidth() + "x" + properties.imageHeight()
    }
    MyHeader {
        title: qsTr("Image info")
    }
    MyInfoItem {
        id: imageResolutionInfoItem
        text: qsTr("Resolution")
    }
    Image {
        id: imageView
        asynchronous: true
        cache: false
        smooth: true
        mipmap: ui.isDesktop ? true : false
        width:  Math.min(column.width*3/4,column.height*3/4)
        height: imageView.width
        source: "qrc:/qtassets/images/empty.png"
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

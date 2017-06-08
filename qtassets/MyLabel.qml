import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQml 2.2

Label {
    color: "white"
    linkColor:  "#0092cc"
    maximumLineCount: 1
    elide: Text.ElideRight
    renderType: Text.QtRendering

    function setAsLinkItem() {
        color = linkColor
        font.underline = true
    }

    onLinkActivated: {
        Qt.openUrlExternally(link)
    }
}

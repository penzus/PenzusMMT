import QtQuick 2.6

MyLabel {
    text: "00:00"
    anchors.verticalCenter: parent.verticalCenter

    function reset() {
        text = "00:00"
    }
}

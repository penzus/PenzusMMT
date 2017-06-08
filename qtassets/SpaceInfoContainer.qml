import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Item {
    id: spaceInfoContainerItem
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        initialize()
    }

    signal mountPointSelected(string path)

    function onComponentClicked(userData) {
        mountPointSelected (storageInfo.rootPath(userData) )
    }

    function removeAll() {
        for (var i =0; i < spaceInfoContainer.children.length; i++ ) {
            spaceInfoContainer.children[i].destroy()
        }
    }

    function initialize() {
        var mountedVolumes = storageInfo.mountedVolumes()
        for (var i = 0; i < mountedVolumes.length; i++) {
            var component = Qt.createComponent("SpaceInfoComponent.qml")
            var spaceInfoItem = component.createObject(spaceInfoContainer)

            spaceInfoItem.headerTitle = mountedVolumes[i]
            spaceInfoItem.userData = i
            var usedPercent = storageInfo.usedPercent(i)
            spaceInfoItem.headerSubTitle = (usedPercent >= 0) ? (usedPercent + "%") : "-"
            spaceInfoItem.progress = (usedPercent >= 0) ? (usedPercent) : 0
            spaceInfoItem.text = storageInfo.usedInfoString(i)

            spaceInfoItem.clicked.connect(spaceInfoContainerItem.onComponentClicked)

        }
    }

    Column {
        id: spaceInfoContainer
        width: parent.width - 2 * ui.defautMargin
        spacing: ui.defautColumnSpacing * 2
        anchors.topMargin: ui.defautColumnSpacing
        anchors.bottomMargin: ui.defautColumnSpacing
        anchors.centerIn: parent
    }
}

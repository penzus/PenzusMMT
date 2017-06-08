import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."
import QtQuick.Window 2.2

Item {
    id: backgroundRectangle
    objectName: "PropertiesPage"
    width: parent.width
    height: parent.height

    property string title: qsTr("Properties")

    Component.onCompleted:  {
        appWindow.hideAppMenu()
        appWindow.changeTitle(title)
        initialize()
    }

    function initialize() {
        contentsInfoItem.text2 = qsTr("calculating...")
        contentsInfoItem.visible = false
        rightsInfoItem.visible = true
        creationDateInfoItem.visible = true
        modDateInfoItem.visible = true

        if (properties.isFile()) {
            headerFileInfo.title = qsTr("File info")
            fileInfoItem.text = qsTr("File")
            fileInfoItem.text2 = properties.getFileName()
            pathInfoItem.text2 = properties.getHumanReadablePath()
            sizeInfoItem.text2 = properties.getHumanReadableFileSize() + "  " + properties.getHumanReadableFileSizeBytes()
            rightsInfoItem.text2 = properties.getRightsDescription()
            creationDateInfoItem.text2 = properties.getCreated()
            modDateInfoItem.text2 = properties.getModified()

            if (properties.isAudioFileWithEditableTags()) {
                segmentedControl.visible = true
                audioInfoContainer.visible = true
                var tagEditor = properties.tagEditor()
                typeInfoItem.text2 = properties.getType()
                bitrateInfoItem.text2 = tagEditor.getBitrate()
                sampleRateInfoItem.text2 = tagEditor.getSampleRate()
                channelsInfoItem.text2  = tagEditor.getChannels()
                lengthInfoItem.text2 = tagEditor.getLength()
                var tagInfo = tagEditor.tagInfo()
                titleItem.text2 = tagInfo.title
                artistItem.text2 = tagInfo.artist
                albumItem.text2 = tagInfo.album
                genreItem.text2 = tagInfo.genre
                commentItem.text2 = tagInfo.comment
                trackItem.text2 = (tagInfo.track > 0) ? tagInfo.track : ""
                yearItem.text2 = (tagInfo.year > 0) ? tagInfo.year : ""

                coverContainer.initialize()

                titleBar.setDismissAction(dismissAction)
                acceptAction.title = qsTr("OK")

            } else if (properties.isImage()){
                extendedInfoComponentLoader.source = "ImageInfoComponent.qml"
                extendedInfoComponentLoader.item.width = column.width
                extendedInfoComponentLoader.item.initialize(properties.getAbsoluteFilePath())

            } else if (properties.isAudioFile()) {
                extendedInfoComponentLoader.source = "AudioInfoComponent.qml"
                extendedInfoComponentLoader.item.width = column.width
                extendedInfoComponentLoader.item.initialize(properties.getAbsoluteFilePath())

            } else if (properties.isVideoFile()) {
                extendedInfoComponentLoader.source = "AudioVideoInfoComponent.qml"
                extendedInfoComponentLoader.item.width = column.width
                extendedInfoComponentLoader.item.initialize(properties.getAbsoluteFilePath())

            } else {
                console.log("properties: unknown file: " + properties.getFileName())
            }

        } else if (properties.isDir()){
            headerFileInfo.title = qsTr("Folder info")
            fileInfoItem.text = qsTr("Folder")
            contentsInfoItem.visible = true
            otherInfoContainer.visible = false///settings.allowEditNoMultimedia

            if (otherInfoContainer.visible) {
                noMultimediaCheckBox.checked = properties.hasNoMultimediaProperty()
            }

            fileInfoItem.text2 = properties.getFileName()
            pathInfoItem.text2 = properties.getHumanReadablePath()
            sizeInfoItem.text2 = properties.getHumanReadableFileSize()
            rightsInfoItem.text2 = properties.getRightsDescription()
            creationDateInfoItem.text2 = properties.getCreated()
            modDateInfoItem.text2 = properties.getModified()

        } else if (properties.isMultipleItems()) {
            headerFileInfo.title = qsTr("Selected items info")
            fileInfoItem.text = qsTr("Selected")
            fileInfoItem.text2 = qsTr("calculating...")
            contentsInfoItem.visible = true

            fileInfoItem.text2 = properties.getFileName()
            pathInfoItem.text2 = properties.getHumanReadablePath()
            sizeInfoItem.text2 = properties.getHumanReadableFileSize()

            rightsInfoItem.visible = false
            creationDateInfoItem.visible = false
            modDateInfoItem.visible = false

        } else {
            console.log("properties: Unknow type")
        }
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

            onWidthChanged: {
                extendedInfoComponentLoader.updateChilds()
            }

            function updatePrivateInfo(directoriesCount,filesCount) {
                return qsTr("folder count") + ": " + directoriesCount + ", " + qsTr("file count" )  +  ": " + filesCount
            }

            Connections {
                target: properties

                onDirectoryContentInfoChanged: {
                    sizeInfoItem.text2 = totalSize
                    contentsInfoItem.text2 = column.updatePrivateInfo(directoriesCount,filesCount)
                }
            }
            Connections {
                target: properties

                onSelectedItemsInfoChanged: {
                    fileInfoItem.text2 =  column.updatePrivateInfo(directoriesCount,filesCount)
                }
            }

            MySpacer {

            }

            Column {
                id: infoContainer
                width: parent.width
                spacing: ui.defautColumnSpacing

                MyHeader {
                    id: headerFileInfo
                    title: qsTr("File info")
                }

                MyInfoItem {
                    id: fileInfoItem
                    multiline: true
                    text: qsTr("File")
                }

                MyInfoItem {
                    id: pathInfoItem
                    multiline: true
                    text: qsTr("Path")
                }

                MyInfoItem {
                    id: contentsInfoItem
                    multiline: true
                    text: qsTr("Contents")
                }

                MyInfoItem {
                    id: sizeInfoItem
                    text: qsTr("Size")
                }

                MyInfoItem {
                    id: rightsInfoItem
                    text: qsTr("Permissions")
                }

                MyInfoItem {
                    id: creationDateInfoItem
                    text: qsTr("Created")
                }

                MyInfoItem {
                    id: modDateInfoItem
                    text: qsTr("Modified")
                }
            }

            Column {
                id: otherInfoContainer
                visible: false
                width: parent.width
                spacing: ui.defautColumnSpacing

                MyHeader {
                    title: qsTr("Other")
                }

                MyCheckBox {
                    id: noMultimediaCheckBox
                    text: qsTr("No media")
                }
            }

            Loader {
                id: extendedInfoComponentLoader

                function updateChilds() {
                    if (ui.isDesktop) {
                        return
                    }
                    if (extendedInfoComponentLoader.item) {
                        extendedInfoComponentLoader.item.width = column.width
                    }
                }
            }

            MySpacer {

            }
        }
    }
}

import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Penzus 1.0
// Needed for singletons QTBUG-34418
import "."

Item {
    id: backgroundRectangle
    objectName: "FileManagerPage"
    width: parent.width
    height: parent.height

    property string title: qsTr("My files")
    property variant lastSelectedFiles
    property variant filter: [ "*.*" ]
    property variant directories: [ "" ]
    property int mode: FilePickerMode.Other
    property int type: FileType.Other
    property bool allowOverwrite: false

    signal fileSelected(var selectedFiles)

    function updateMenu() {
        if (visible) {
            appWindow.changeTitle(title)
            var mountedVolumes = storageInfo.mountedVolumes()

            if (mountedVolumes.length > 0) {
                appWindow.showAppMenu(false)
            } else {
                appWindow.hideAppMenu()
                return
            }

            for (var i = 0; i < mountedVolumes.length; i++) {
                appWindow.setContextMenuItemState(i,true,true)
                appWindow.setContextMenuItemText(i, mountedVolumes[i])
            }
        }
    }

    function showMountedVolumesComponentVisible(visible) {
        parentColumn.visible = !visible
        if (visible) {
            appWindow.hideAppMenu()
        } else {
            updateMenu()
        }
    }

    function customMenuItemClicked(index) {
        var storage = storageInfo.rootPath(index)
        fileItemModel.setCurrentDirectory(storage)
        backgroundRectangle.showMountedVolumesComponentVisible(false)
    }

    onVisibleChanged: {
        updateMenu()
    }

    Component.onDestruction: {
        appWindow.popTransitionEnded(objectName)
    }

    function setInitialDirectory(defaultDirectory) {
        if (mode === FilePickerMode.Saver) {
            var directoryName = fileUtils.absolutePath(directories[0])
            if (!fileUtils.directoryOrFileExists(directoryName))  {
                header.text = defaultDirectory
            } else {
                header.text = directoryName
            }
        } else {
            if  ( (directories.length == 0 ) || (!fileUtils.directoryOrFileExists(directories[0]) ) ){
                header.text = defaultDirectory
            } else {
                header.text = directories[0]
            }
        }
        fileItemModel.clearSelection()
        fileItemModel.setCurrentDirectory(header.text)
    }

    Component.onCompleted: {
        appWindow.changeTitle(title)
        var mountedVolumes = storageInfo.mountedVolumes()
        fileItemModel.setCachedMountVolumes(mountedVolumes)


        if (mode === FilePickerMode.SaverMultiple) {
            fileItemModel.setType(0)
            var array = []
            fileItemModel.setFilter(array)
            setInitialDirectory(settings.defaultOutputDir)

        } else if (mode === FilePickerMode.Picker) {
            header.text = settings.defaultRootDirectory()
            fileItemModel.setType(type)
            fileItemModel.setFilter(filter)
            button.visible = false
            fileItemModel.setCurrentDirectory(header.text)

        } else if (mode === FilePickerMode.Saver){
            fileItemModel.setType(type)
            fileItemModel.setFilter(filter)
            textField.visible = true
            setInitialDirectory(settings.defaultRootDirectory())
            textField.text = fileUtils.fileName(directories[0])
            button.startTimer()

        } else if (mode === FilePickerMode.Other) {
            button.visible = false
            fileItemModel.setType(type)
            fileItemModel.setFilter(filter)
            setInitialDirectory(settings.defaultOutputDir)
        } else if (mode === FilePickerMode.PickerMultiple)  {
            button.visible = true
            fileItemModel.setType(type)
            fileItemModel.setFilter(filter)
            setInitialDirectory(settings.defaultOutputDir)
        }

        appWindow.hideAppMenu()

        if ( (mode === FilePickerMode.Other) || (mode === FilePickerMode.Saver) || (mode === FilePickerMode.SaverMultiple) || (mountedVolumes.length === 1)) {
            showMountedVolumesComponentVisible(false)
        }
    }

    Rectangle {
        id: rect
        width: Math.min(backgroundRectangle.width, ui.maximumPageWidth)
        height: backgroundRectangle.height
        color : "transparent"
        anchors.centerIn: backgroundRectangle
    }

    SpaceInfoContainer {
        id: spaceInfoContainer
        width: rect.width - 2 * anchors.leftMargin
        anchors.centerIn: rect
        visible: !parentColumn.visible
        onMountPointSelected: {
            fileItemModel.setCurrentDirectory(path)
            backgroundRectangle.showMountedVolumesComponentVisible(false)
        }
        Connections {
            target: fileItemModel
            onJumpedOverMountVolume: {
                backgroundRectangle.showMountedVolumesComponentVisible(true)
            }
        }
    }

    Column {
        id: parentColumn
        spacing: 0
        visible: false
        anchors.leftMargin: ui.defautMargin
        width: rect.width - 2 * anchors.leftMargin
        anchors.horizontalCenter: rect.horizontalCenter

        Rectangle {
            id: baseRectangle
            color: appWindow.appColor
            width: parentColumn.width
            height: column.height
            anchors.horizontalCenter: parentColumn.horizontalCenter
            z: 1

            Column {
                id: column
                spacing: ui.defautColumnSpacing
                anchors.leftMargin: ui.defautMargin
                width: rect.width - 2 * anchors.leftMargin
                anchors.horizontalCenter: baseRectangle.horizontalCenter

                MySpacer {
                    id: spacer1
                }

                Row {
                    id: row1
                    spacing: ui.defautRowSpacing
                    width: column.width
                    height: button.visible ? spacer3.height : header.height

                    MyLabel {
                        z: 2
                        id: header
                        anchors.verticalCenter: row1.verticalCenter
                        width: row1.width - (button.visible ? (button.width + row1.spacing): 0)
                        elide: Text.ElideLeft
                    }

                    MyImageButton {
                        id: button
                        height: row1.height
                        width: 3 * header.height
                        anchors.verticalCenter: row1.verticalCenter
                        imageSource:   "qrc:/qtassets/images/done.png"

                        function startTimer() {
                            if (textField.visible) {
                                timer.start()
                            }
                        }

                        function stopTimer() {
                            timer.stop()
                        }

                        Timer {
                            id: timer
                            repeat: true
                            interval: 250
                            onTriggered : {
                                if (!textField.visible) {
                                    stop()
                                }
                                button.enabled = textField.isValidData()
                            }
                        }

                        onClicked: {
                            var selectedFiles = []

                            if (mode === FilePickerMode.Saver){
                                var savedFileName = fileUtils.mergePathWithName(header.text,textField.text)
                                if (!textField.isValidData()) {
                                    appWindow.showPopupMessage(qsTr("Please enter valid filename."))
                                    return
                                }
                                selectedFiles.push(savedFileName)
                            } else if (mode === FilePickerMode.PickerMultiple) {
                                selectedFiles = fileItemModel.selectedFiles()
                                if (selectedFiles.length <= 1) {
                                    appWindow.showPopupMessage(qsTr("Please select more than one file."))
                                    return
                                }

                                if (!fileUtils.filesWithSameResolution(selectedFiles)) {
                                    appWindow.showPopupMessage(qsTr("Please select only the files with the same resolution."))
                                    return
                                }

                            } else if (mode === FilePickerMode.SaverMultiple ) {
                                if (!fileUtils.isTopLevelDir(header.text)) {
                                    selectedFiles.push(header.text)
                                } else {
                                    appWindow.showPopupMessage(qsTr("This folder is root folder. Please select another."))
                                    return
                                }
                            } else {
                                selectedFiles.push(header.text)
                            }
                            backgroundRectangle.fileSelected(selectedFiles)
                            stackView.pop()
                        }
                    }
                }

                TextField  {
                    id: textField
                    width: column.width
                    visible: false
                    placeholderText: qsTr("Enter name")
                    selectByMouse: true

                    function isValidData() {
                        if (!visible) {
                            return true
                        }
                        return (!mml.stringIsEmpty(textField.text))
                    }

                    onEditingFinished: {
                        console.log("textField.text: ###" + textField.text + "###")
                    }
                }

                MySpacer {
                    id: spacer2
                    color: appWindow.appColor
                }
            }
        }

        ListView {
            id: listView
            width: column.width
            model: fileItemModel
            y: column.y + column.height
            height: rect.height - baseRectangle.height - spacer3.height - spacer2.height
            z: -1

            property string selectedFileNamePath

            Connections {
                target: fileItemModel

                onCurrentDirectoryChanged: {
                    header.text = directory
                    var availableSpaceSize = storageInfo.availableSizeString(directory)
                    var additionalInfo = ""
                    if (availableSpaceSize.length > 0) {
                        additionalInfo = ", " + qsTr("free space") + ": " + availableSpaceSize
                    }
                    footerLabel.text = fileItemModel.getStatusBarText() + additionalInfo
                }
            }

            delegate: MyListItem {
                text: fileName
                imageSource:  imageSourcePath
                status: statusString
                imageVisible: true
                description: descriptionString
                selectionAtMousePress: ((backgroundRectangle.mode===FilePickerMode.PickerMultiple) ) ? false : true
                multiSelectionMode: ((backgroundRectangle.mode===FilePickerMode.PickerMultiple) ) ? true : false
                itemSelectionEnabled: ((backgroundRectangle.mode===FilePickerMode.SaverMultiple) ) ? false : true
                fileNamePathValue: fileNamePath

                onPressAndHold: {
                    if (!fileUtils.contextMenuCanOpen(fileItemModel.getCurrentDirectory(), fileNamePath)) {
                        return
                    }

                    listView.selectedFileNamePath = fileNamePath
                    contextMenu.invoke()
                }

                onClicked: {
                    if (isDir) {
                        fileItemModel.setCurrentDirectory(fileNamePath)
                    } else {
                        if (mode === FilePickerMode.Picker) {
                            var selectedFiles = []
                            selectedFiles.push(fileNamePath)
                            backgroundRectangle.fileSelected(selectedFiles)
                            stackView.pop()
                        } else if ((mode === FilePickerMode.Other) || (mode === FilePickerMode.Saver)) {
                            appWindow.openFile(fileUtils.pathToUrl(fileNamePath))
                        }  if (mode === FilePickerMode.PickerMultiple) {
                            // nothing to do
                        }
                    }
                }
            }
            MessageDialog {
                id: deleteConfirmDialog
                title: qsTr("Warning")
                standardButtons: StandardButton.Ok | StandardButton.Cancel

                function invoke() {
                    popupMessage.cancel()
                    deleteConfirmDialog.text = qsTr("Do you really want to delete selected item?")
                    deleteConfirmDialog.visible = true
                }
                onAccepted: {
                    if (fileUtils.deleteFileItem(listView.selectedFileNamePath)) {
                        popupMessage.show(qsTr("Item deleted successfully"))
                    } else {
                        popupMessage.show(qsTr("Error deleting item"))
                    }
                }
            }
            Menu {
                id: contextMenu
                title: qsTr("Actions")

                property bool isDir: false
                function invoke() {
                    contextMenu.isDir = fileUtils.isDir(listView.selectedFileNamePath)
                    shareMenuItem.visible = !contextMenu.isDir && !ui.isDesktop
                    contextMenu.popup()
                }

                MenuItem {
                    id: openMenuItem
                    text: qsTr("Open")
                    onTriggered: {
                        if (contextMenu.isDir) {
                            fileItemModel.setCurrentDirectory(listView.selectedFileNamePath)
                        } else {
                            appWindow.openFile(listView.selectedFileNamePath)
                        }
                    }
                }
                MenuItem {
                    id: renameMenuItem
                    text: qsTr("Rename")
                    onTriggered: {
                        systemInputDialog.addMode = false
                        systemInputDialog.confirmButtonText = qsTr("Rename")
                        systemInputDialog.title = qsTr("Enter a new name")
                        systemInputDialog.fileNamePath = listView.selectedFileNamePath
                        systemInputDialog.show()
                        if (contextMenu.isDir) {
                            systemInputDialog.text = fileUtils.fileName(listView.selectedFileNamePath)
                        } else {
                            systemInputDialog.suffix = fileUtils.suffix(listView.selectedFileNamePath)
                            systemInputDialog.text = fileUtils.completeBaseName(listView.selectedFileNamePath)
                        }
                    }
                }
                MenuItem {
                    id: deleteMenuItem
                    text: qsTr("Delete")
                    onTriggered: {
                        deleteConfirmDialog.invoke()
                    }
                }

                MenuItem {
                    id: shareMenuItem
                    text: qsTr("Share")
                    onTriggered: {
                        myApp.shareMediaFile(listView.selectedFileNamePath)
                    }
                }

                MenuSeparator {

                }

                MenuItem {
                    id: propertiesMenuItem
                    text: qsTr("Properties")
                    onTriggered: {
                        properties.setPath(listView.selectedFileNamePath)
                        appWindow.gotoPage("PropertiesPage.qml")
                    }
                }
            }
        }
    }
    Rectangle {
        id: spacer3
        visible: parentColumn.visible
        width: rect.width
        height: footerLabel.height + 2 * ui.defautMargin
        color: "#191919"
        anchors.bottom: rect.bottom
        anchors.horizontalCenter: rect.horizontalCenter
        MyLabel {
            id: footerLabel
            color: "grey"
            anchors.verticalCenter: parent.verticalCenter
            x: ui.defautMargin
        }
    }
    MySystemToast {
        id: popupMessage
        function show(message) {
            displayMessage(message)
        }
    }
    MySystemInputDialog {
        id: systemInputDialog
        property bool addMode: false
        property string fileNamePath
        property string suffix
        onAccepted: {
            if (addMode) {
                // todo
            } else { // rename mode
                if (!(fileUtils.renameFileItem(fileNamePath, text, false).length)) {
                    appWindow.showPopupMessage(qsTr("Cannot rename item!"))
                }
            }
        }
    }
}

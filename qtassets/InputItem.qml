import QtQuick 2.6
import QtQuick.Controls 1.4
import Penzus 1.0
// Needed for singletons QTBUG-34418
import "."

Column {
    id: inputItem
    width: parent.width

    property alias title: header.title
    property alias fileName: dataLabel.text
    property alias inputFileNames: filePicker.lastSelectedFiles
    property alias statusVisible: statusLabel.visible

    property string absFileNamePath0
    property string previewFileNamePath

    signal absFileNamePathChanged(string newAbsFileNamePath)
    signal pickerMultipleNotAccepted()


    function reset() {
        dataLabel.text = ""
        statusLabel.visible = false
        pathLabel.visible = false
    }
    
    function setFilter(extension) {
        filePicker.filter = extension
    }

    function setTypeMusic(extension) {
        filePicker.type = FileType.Music
        filePicker.filter = extension
    }
    
    function setTypePicture(extension) {
        filePicker.type = FileType.Picture
        filePicker.filter = extension
    }
    
    function updateStatus() {
        if (absFileNamePath0.length > 0 ) {
            pathLabel.text = qsTr("Path:" ) + " " + fileUtils.absolutePath(absFileNamePath0,true)
            pathLabel.visible = true
        } else {
            pathLabel.visible = false
        }
        
        statusLabel.visible = (filePicker.mode !== FilePickerMode.SaverMultiple)
        if (!mml.fileExists(absFileNamePath0) || fileUtils.isDir(absFileNamePath0)) {
            statusLabel.visible = false
            return
        }
        
        if (filePicker.mode !== FilePickerMode.SaverMultiple) {
            if ( filePicker.mode === FilePickerMode.PickerMultiple) {
                statusLabel.text = qsTr("Total size:" ) + " " + mml.humanReadableFileSize2(filePicker.lastSelectedFiles)
            } else {
                statusLabel.text = qsTr("File size:" ) + " " + mml.humanReadableFileSize(absFileNamePath0)
            }
        }
    }
    
    function setMode(newMode) {
        filePicker.mode = newMode
        if ( filePicker.mode === FilePickerMode.PickerMultiple) {
            header.title = qsTr("Input files")
        }
    }
    
    function update() {
        if ( filePicker.mode === FilePickerMode.PickerMultiple) {
            if (filePicker.lastSelectedFiles.length > 0) {
                dataLabel.text = "<" + qsTr("Selected files:" ) + " " + filePicker.lastSelectedFiles.length +  ">"
            }
        } else {
            dataLabel.text = extractFileNameFromPath(absFileNamePath0)
        }
        dataLabel.visible = true
        updateStatus()
    }
    
    function extractFileNameFromPath(fileName) {
        return fileName.substring(fileName.lastIndexOf("/") + 1, fileName.length)
    }

    Column {
        id: column
        spacing: ui.defautColumnSpacing
        width: inputItem.width
        MyHeader {
            id: header
            title: qsTr("Input file")
            width: inputItem.width
        }
        Row {
            id: row
            spacing: ui.defautRowSpacing
            width: inputItem.width

            MyLabel {
                id: notSetLabel
                anchors.verticalCenter: row.verticalCenter
                visible: dataLabel.text.length == 0
                text: qsTr("<Not selected>")
                color: "red"
                width: row.width - selectFileButton.width - row.spacing
            }
            MyLabel {
                id: dataLabel
                visible: false
                anchors.verticalCenter: row.verticalCenter
                width: row.width - selectFileButton.width - row.spacing
            }


            MyButton {
                id: selectFileButton
                text: qsTr("Select")
                anchors.verticalCenter: row.verticalCenter
                function selectFile() {
                    filePicker.title = qsTr("Select file")
                    if ( filePicker.mode === FilePickerMode.Saver) {
                        filePicker.directories = [ absFileNamePath0 ]
                    }
                    filePicker.open()
                }
                function selectFiles() {
                    filePicker.title = qsTr("Select files")
                    filePicker.mode = FilePickerMode.PickerMultiple //нужно ли?
                    filePicker.open()
                }

                function selectDir() {
                    filePicker.title = qsTr("Select folder")
                    filePicker.mode = FilePickerMode.SaverMultiple
                    filePicker.directories = [ absFileNamePath0 ]
                    filePicker.open()
                }

                onClicked: {
                    if ( filePicker.mode === FilePickerMode.PickerMultiple) {
                        selectFiles()
                    } else {
                        if (absFileNamePath0.length) {
                            if (fileUtils.isDir(absFileNamePath0)) {
                                selectDir()
                                return
                            } else {
                                // отключено для существующих файлов, потому что народу не понравилось
                                if (!mml.fileExists(absFileNamePath0)) {
                                    filePicker.directories = [ fileUtils.absolutePath(absFileNamePath0) ]
                                }
                            }
                        }
                        selectFile()
                    }
                }
            }
        }

        MyLabel {
            id: pathLabel
            visible: dataLabel.visible
            text: "Path: "
            color: "gray"
            width: inputItem.width
        }

        Label {
            id: statusLabel
            visible: false
            text: "File size: "
            color: "gray"
            width: inputItem.width
        }
    }

    Loader {
        id: filePicker
        property string title: qsTr("Select")
        property variant lastSelectedFiles
        property int mode: FilePickerMode.Picker
        property bool allowOverwrite: false
        property int type: FileType.Video
        property variant filter: [ "*.*" ]
        property variant directories: [ "" ]

        function open() {
            appWindow.hideAppMenu()
            var loadedItem = stackView.push({item:Qt.resolvedUrl("FileManagerPage.qml"),
                                                properties:{mode:filePicker.mode,
                                                    type:filePicker.type,
                                                    filter:filePicker.filter,
                                                    title:filePicker.title,
                                                    directories:filePicker.directories}})

            loadedItem.fileSelected.connect(onFileSelected)
        }

        function onFileSelected(selectedFiles) {
            if ( filePicker.mode === FilePickerMode.PickerMultiple) {
                if (selectedFiles.length === 1) {
                    pickerMultipleNotAccepted()
                    return
                }
            }
            inputItem.absFileNamePath0 = selectedFiles[0]
            filePicker.lastSelectedFiles = selectedFiles.slice()

            inputItem.update()
            inputItem.absFileNamePathChanged(inputItem.absFileNamePath0)
        }
    }
}

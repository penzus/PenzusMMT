import QtQuick 2.6
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtMultimedia 5.6
import Template 1.0
import ConsoleTestConnection 1.0
import MediaInfoConnection 1.0
import MediaInfo 1.0
import Penzus 1.0
// Needed for singletons QTBUG-34418
import "."

Item {
    id: backgroundRectangle
    width: parent.width
    height: parent.height
    objectName: "ConfigurePage"

    property int itemId: -1
    property string title:  qsTr("Configure and start")
    property string menuItem1Text: qsTr("Delete output files")

    function updateGui() {
        if (visible) {
            appWindow.showAppMenu(false)

            appWindow.setContextMenuItemState(0,configurePage.finishedSuccess && outputFileItem.visible,true)
            appWindow.setContextMenuItemText(0,menuItem1Text)

            appWindow.changeTitle(title)
        }
    }

    function customMenuItemClicked() {
        deleteConfirmDialog.invoke()
    }

    onVisibleChanged: {
        updateGui()
    }

    Component.onCompleted: {
        configurePage.initializeData(backgroundRectangle.itemId)
        updateGui()
    }

    Component.onDestruction: {
        appWindow.popTransitionEnded(backgroundRectangle.objectName)
    }

    Rectangle {
        id: rect
        width: Math.min(backgroundRectangle.width, ui.maximumPageWidth)
        height: backgroundRectangle.height
        color : "transparent"
        anchors.centerIn: backgroundRectangle
    }

    Flickable {
        id: configurePage
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: rect
        clip: true
        contentWidth: column.width;
        contentHeight: column.height
        anchors.centerIn: rect

        property bool finishedSuccess: false
        property bool playMIMESupported: false
        property bool hasEditableVideo: false


        function showMessage(message) {
            appWindow.showPopupMessage(message)
        }

        function operationFinished(result) {
            finishedSuccess = result
        }

        function initializeData(templateId) {
            if (templateId === templates.reserveredMultiTemplateId() ) {
                templateId = templates.firstTemplateIdForReserveredMultiTemplateId()
                templateSelectionDropDown.selectedIndex = 0
                multiTemplateSelectionContainer.visible = true
            }

            optionsContainer.removeAll()
            optionsContainer.visible = false
            templates.setCurrentTemplate(templateId)
            inputFileItem.visible = templates.currentTemplate.hasInputFile()

            if (templates.currentTemplate.hasInputFileHeaderInfo()) {
                inputFileItem.title = templates.currentTemplate.getInputFileHeaderInfo()
            }

            inputFileSecondAudioItem.visible = templates.currentTemplate.hasInputSecondAudioFile()
            outputFileItem.visible = templates.currentTemplate.hasOutputFile()
            outputDirItem.visible = templates.currentTemplate.hasOutputDir()
            titleLabel.text = templates.currentTemplate.getTitle()

            if (outputDirItem.visible) {
                outputDirItem.absFileNamePath0 = settings.defaultOutputDir
                outputDirItem.update()
            }

            if (templates.currentTemplate.inputTypeIsMusic()) {
                inputFileItem.setTypeMusic(templates.currentTemplate.getInputFileExtensions())
            } else if (templates.currentTemplate.inputTypeIsPicture()) {
                inputFileItem.setTypePicture(templates.currentTemplate.getInputFileExtensions())
            } else {
                inputFileItem.setFilter(templates.currentTemplate.getInputFileExtensions())
            }

            if (templates.currentTemplate.hasMultipleInputData()) {
                inputFileItem.setMode(FilePickerMode.PickerMultiple)
            } else {
                inputFileItem.setMode(FilePickerMode.Picker)
            }

            // Options
            if (templates.currentTemplate.optionsCount() > 0 ) {
                for (var i = 0; i < templates.currentTemplate.optionsCount(); i++) {
                    var component = Qt.createComponent("MyDropDown.qml")
                    if (component.status === Component.Ready) {
                        //
                    }
                    var myDropDownItem = component.createObject(optionsContainer)
                    var option = templates.currentTemplate.optionAtIndex(i)
                    myDropDownItem.title = option.getTitle()
                    myDropDownItem.objectName = option.getTitle() // just for check

                    for (var j = 0; j < option.optionItemsCount(); j++) {
                        var optionItem = option.opionItemAtIndex(j)
                        myDropDownItem.appendOption(optionItem.getTitle(), "1")
                    }
                    myDropDownItem.setSelectedIndex(option.getSelectedOptionItemIndex())
                }
                optionsContainerExtended.visible = true
                optionsContainer.visible = true
            }

            if (inputFileSecondAudioItem.visible) {
                inputFileSecondAudioItem.setTypeMusic(templates.currentTemplate.defaultAudioFileNameExtension())
            }

            if (templates.currentTemplate.hasTimeSelector()) {
                optionsContainerExtended.visible = true
                timeSelectorContainer.visible = true
            }
        }

        Column {
            id: column
            spacing: ui.defautColumnSpacing
            anchors.leftMargin: ui.defautMargin
            width: configurePage.width - 2 * anchors.leftMargin
            anchors.left: parent.left

            onWidthChanged:  {
                if (width > 0) {
                    titleLabel.width = column.width - 2*column.spacing
                    titleLabel.updateGui()
                }
            }

            MySpacer {

            }

            MyLabel {
                id: titleLabel
                text: qsTr("Configure and start")
                font.bold: true
                font.underline: true
                color: "steelblue"
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                anchors.horizontalCenter: column.horizontalCenter

                property bool textInitialized: false

                function updateGui() {
                    if ( (contentWidth >= (column.width - 2*column.spacing ) ) ) {
                        width = column.width - 2*column.spacing
                    } else {
                        if (textInitialized) {
                            width = contentWidth
                        }
                    }
                    textInitialized = true
                }

                onTextChanged: {
                    updateGui()
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appWindow.showInfoDialog(templates.currentTemplate, titleLabel.text)
                    }
                }
            }

            MySpacer {

            }

            InputItem {
                id: inputFileItem
                title: qsTr("Input file")

                function updateIfFileExists(newAbsFileNamePath) {
                    if (newAbsFileNamePath.length === 0) {
                        return
                    }

                    var newDefaultFileNamePath = templates.currentTemplate.createOutputFileNamePath(newAbsFileNamePath)

                    if (templates.currentTemplate.hasTimeSelector()) {
                        if (!timeSelectorContainer.setFileName(newAbsFileNamePath)) {
                            appWindow.showPopupMessage(qsTr("File cannot be loaded into media player. Make sure the file can be played by means of this OS."))
                            // reset input selectors?
                            inputFileItem.reset()
                            outputFileItem.reset()
                            return
                        }
                    }

                    if (templates.currentTemplate.hasOutputFile()) {
                        outputFileItem.absFileNamePath0 = newDefaultFileNamePath
                        outputFileItem.update()
                    }
                }

                onAbsFileNamePathChanged: {
                    updateIfFileExists(newAbsFileNamePath)
                }
            }

            InputItem {
                id: inputFileSecondAudioItem
                visible: false
                title: qsTr("Input Audio File")
                Component.onCompleted: {
                    setMode(FilePickerMode.Picker)
                }
            }

            InputItem {
                id: outputFileItem
                title: qsTr("Output file")
                function postSelectionHandler(newAbsFileNamePath) {

                    if (!newAbsFileNamePath.length) {
                        return
                    }

                    var correctedFileName = templates.currentTemplate.correctOutputFileExtension(newAbsFileNamePath)
                    if (correctedFileName !== newAbsFileNamePath) {
                        outputFileItem.absFileNamePath0 = correctedFileName
                        outputFileItem.update()
                    }
                }

                onAbsFileNamePathChanged: {
                    postSelectionHandler(newAbsFileNamePath)
                }

                Component.onCompleted: {
                    setMode(FilePickerMode.Saver)
                }
            }

            InputItem {
                id: outputDirItem
                title: qsTr("Output folder")
            }

            MediaPlayer {
                id: systemSound
                source:  "qrc:/qtassets/data/notification.mp3"
            }

            ConsoleTestConnection {
                id: consoleTestConnection
                onCurrentProgressChanged: {
                    progressDialog.progress = currentValue
                    progressDialog.statusMessage = currentValue + "%"
                }
                onTestConnectionFinished: {
                    configurePage.finishedSuccess = (exitCode == 0) ? true : false
                    var result = consoleTestConnection.outputString()
                    var notificationWhenOperationFinished = true
                    if (progressDialog.activityIndicatorVisible) {
                        progressDialog.showPostProcessMessage(exitCode)
                    } else {
                        notificationWhenOperationFinished = false
                    }

                    configurePage.playMIMESupported = false
                    configurePage.hasEditableVideo = false
                    if (configurePage.finishedSuccess) {
                        progressDialog.progress = 100
                        progressDialog.statusMessage = "100%"
                        configurePage.playMIMESupported = myApp.playMIMESupported(outputFileItem.absFileNamePath0)
                        configurePage.hasEditableVideo = myApp.hasEditableVideo(outputFileItem.absFileNamePath0)
                    }

                    outputFileItem.updateStatus()

                    if (notificationWhenOperationFinished) {
                        if (settings.enableLEDWhenFinished) {
                            // todo
                        }

                        if (settings.playSoundWhenFinished) {
                            systemSound.play()
                        }
                        if (settings.vibrateWhenFinished) {
                            vibrationController.start()
                        }
                    }

                    settings.setProcessMode(false)
                    templates.currentTemplate.postProcessingCleanup()
                    backgroundRectangle.updateGui()
                }
            }

            MessageDialog {
                id: deleteConfirmDialog
                title: qsTr("Warning")
                standardButtons: StandardButton.Ok | StandardButton.Cancel

                function invoke() {
                    appWindow.cancelPopupMessage()
                    deleteConfirmDialog.text = qsTr("Do you really want to delete the file?")
                    deleteConfirmDialog.visible = true
                }

                onAccepted: {
                    if (fileUtils.deleteFileItem(outputFileItem.absFileNamePath0)) {
                        configurePage.showMessage(qsTr("File deleted successfully"))
                    } else {
                        configurePage.showMessage(qsTr("Error deleting file"))
                    }
                    outputFileItem.updateStatus()
                    configurePage.finishedSuccess = false
                    backgroundRectangle.updateGui()
                }
            }

            MySystemProgressDialog {
                id: progressDialog
                title: qsTr("Operation in progress")
                body: " "
                cancelButtonText: qsTr("Cancel")

                function showProgressInfo() {
                    activityIndicatorVisible = true
                    progressDialog.progress = 0
                    progressDialog.statusMessage = "0%"
                    title = qsTr("Operation in progress")
                    body = qsTr("Please wait...")
                    cancelButtonText = qsTr("Cancel")
                    myApp.deleteVideoFile(outputFileItem.absFileNamePath0) // if any file already exists
                    show()
                }

                function showPostProcessMessage(exitCode) {
                    activityIndicatorVisible = false
                    title = qsTr("Operation finished")
                    cancelButtonText = qsTr("Close")
                    body = (qsTr("Status: ") + (exitCode === 0 ? qsTr("success") : qsTr("fail") ) )
                }

                onFinished: {
                    activityIndicatorVisible = false
                    vibrationController.stop()
                    settings.setProcessMode(false)

                    if (cancelButtonText === qsTr("Cancel")) {
                        progressDialog.progress = 0
                        progressDialog.statusMessage = "0%"
                        console.log("SystemProgressDialog: terminated child process")
                        consoleTestConnection.terminateProcess()
                        myApp.deleteVideoFile(outputFileItem.absFileNamePath0)
                        outputFileItem.updateStatus()
                    }
                }
            }

            /// Options
            Column {
                id: optionsContainerExtended
                width: column.width
                visible: {
                    return (multiTemplateSelectionContainer.visible || timeSelectorContainer.visible || optionsContainer.visible )
                }
                MyHeader {
                    title: qsTr("Options")
                }

                Column {
                    id: multiTemplateSelectionContainer
                    visible: false
                    width: parent.width
                    spacing: ui.defautColumnSpacing

                    MySpacer {

                    }

                    MyDropDown {
                        id: templateSelectionDropDown
                        title: qsTr("Format")
                        onInitialized: {
                            appendOption("AAC", (templates.firstTemplateIdForReserveredMultiTemplateId()).toString() )
                            appendOption("FLAC", (templates.firstTemplateIdForReserveredMultiTemplateId() + 1).toString())
                            appendOption("MP3", (templates.firstTemplateIdForReserveredMultiTemplateId() + 2).toString())
                        }
                        onCurrentIndexChanged: {
                            var selectedValue = templateSelectionDropDown.getOptionByValue()

                            if (!templateSelectionDropDown.visible) {
                                return
                            }

                            var savedOutputFileNamePath = outputFileItem.absFileNamePath0
                            configurePage.initializeData(selectedValue)
                            inputFileItem.updateIfFileExists(inputFileItem.absFileNamePath0)

                            if (savedOutputFileNamePath.length) {
                                outputFileItem.postSelectionHandler(savedOutputFileNamePath)
                            }
                        }
                    }
                }

                TimeSelectorComponent {
                    id: timeSelectorContainer
                    visible: false
                }

                MySpacer {

                }

                MySpacer {

                }

                MySpacer {

                }

                MySpacer {

                }

                Column {
                    id: optionsContainer
                    spacing: ui.defautColumnSpacing
                    visible: false
                    width: parent.width

                    function removeAll() {
                        for (var i =0; i < children.length; i++ ) {
                            children[i].destroy()
                        }
                    }
                }
            }
            /// ~Options

            MyHorizontalDivider {
                id: divider1
            }

            MyButton {
                id: startButton
                visible: {
                    return (inputFileItem.visible || outputFileItem.visible || outputDirItem.visible)
                }
                enabled: {
                    if (inputFileItem.visible && inputFileItem.fileName.length == 0) return false
                    if (inputFileSecondAudioItem.visible && inputFileSecondAudioItem.fileName.length == 0) return false
                    if (outputFileItem.visible && outputFileItem.fileName.length == 0) return false
                    if (outputDirItem.visible && outputDirItem.fileName.length == 0) return false
                    if (timeSelectorContainer.visible && (timeSelectorContainer.intervalSelected === false)) return false
                    return true
                }
                text: qsTr("Start")
                anchors.horizontalCenter: column.horizontalCenter

                onClicked: {
                    if (templates.currentTemplate.getResizeInputImageFilename()) {
                        var array = new Array()
                        for (var i = 0; i < optionsContainer.children.length; i++) {
                            var control = optionsContainer.children[i]
                            array.push(control.selectedIndex)
                        }
                        startButton.enabled = false
                        mediaInfoConnection.startProcessPreview(inputFileItem.inputFileNames[0],templates.currentTemplate.arrayOptionToValue(array))
                        return
                    }
                    startProcess()
                }

                function startProcess() {
                    var firstTime = null
                    var secondTime = null

                    appWindow.cancelPopupMessage()
                    if (timeSelectorContainer.visible) {
                        timeSelectorContainer.audioPlayer.stop()
                        firstTime = timeSelectorContainer.firstTime
                        secondTime = timeSelectorContainer.secondTime
                    }
                    var array = new Array()
                    for (var i = 0; i < optionsContainer.children.length; i++) {
                        var control = optionsContainer.children[i]
                        array.push(control.selectedIndex)
                    }

                    var inputFileNames = []
                    if (templates.currentTemplate.getResizeInputImageFilename()) {
                        inputFileNames.push(inputFileItem.previewFileNamePath)
                    } else {
                        inputFileNames = inputFileItem.inputFileNames.slice()
                    }
                    var cmdArgs = templates.currentTemplate.generateCommand(inputFileNames,
                                                                            outputFileItem.absFileNamePath0,
                                                                            outputDirItem.absFileNamePath0,
                                                                            inputFileSecondAudioItem.absFileNamePath0, array, firstTime, secondTime)
                    console.log("ARGS: " + cmdArgs);
                    var imagesCountFromGIF = 0
                    if (inputFileItem.inputFileNames.length > 0) {
                        fileUtils.framesCountFromGIF(inputFileItem.inputFileNames[0])
                    }

                    settings.setProcessMode(true)

                    consoleTestConnection.setProcessChannelMode(1)
                    consoleTestConnection.startProcess(cmdArgs, templates.currentTemplate.calculateProcessDuration(), imagesCountFromGIF)

                    progressDialog.showProgressInfo()
                }
            }

            MySpacer {

            }
            Row {
                spacing: ui.defautRowSpacing
                anchors.horizontalCenter: column.horizontalCenter
                MyImageButton {
                    id: playAction
                    enabled: (configurePage.finishedSuccess && outputFileItem.visible && configurePage.playMIMESupported)
                    text: qsTr("View")
                    imageSource: "qrc:/qtassets/images/play.png"
                    onClicked: {
                        appWindow.openFile(outputFileItem.absFileNamePath0)
                    }
                }

                MyImageButton {
                    id: shareAction
                    visible: !ui.isDesktop
                    text: qsTr("Share")
                    imageSource: "qrc:/qtassets/images/share.png"
                    enabled: (configurePage.finishedSuccess && outputFileItem.visible)
                    onClicked: {
                        myApp.shareMediaFile(outputFileItem.absFileNamePath0)
                    }
                }
                MyImageButton {
                    id: myFilesAction
                    text: qsTr("My files")
                    enabled: true
                    imageSource: "qrc:/qtassets/images/home.png"
                    onClicked: {
                        appWindow.hideAppMenu()
                        appWindow.gotoPage("FileManagerPage.qml")
                    }
                }
            }

            MySpacer {

            }

            MediaInfoConnection {
                id: mediaInfoConnection
                onConnectionPreviewFinished: {
                    inputFileItem.previewFileNamePath = fileNamePath
                    console.log("inputFileItem.previewFileNamePath: " + inputFileItem.previewFileNamePath)
                    startButton.enabled = true
                    startButton.startProcess()
                }
            }
        }
    }
}

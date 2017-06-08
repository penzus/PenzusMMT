import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
// Needed for singletons QTBUG-34418
import "."

ApplicationWindow {
    id: appWindow
    objectName: "AppWindow"
    width: 480
    height: 720
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    title: myApp.officialAppName()

    property alias appColor: backgroundRectangle.color

    Component.onCompleted: {
        if (!ui.isDesktop) {
            var apiVersion = systemTools.getApiVersion()
            if ( apiVersion < 19) {
                messageDialog.fatalError = true
                messageDialog.show( qsTr("Penzus MMT has been developed to work with API version 19 and up. Your device does not meet this requirement. The app is exiting now..."),
                                   qsTr("Critical error"))
            }
        }

        ui.updateFontSizes(dummyLabel.font.pixelSize)
        updateGui()

        if (settings.isFirstRun()) {
            welcomeLoader.source = "WelcomePage.qml"
            welcomeLoader.item.visible = true
        }
    }

    function updateGui() {
        if (ui.isDesktop) {
            appWindow.visibility = Window.Windowed
        } else {
            appWindow.visibility = settings.fullScreenMode ? Window.FullScreen :  Window.AutomaticVisibility
        }
    }

    function openFile(fileNamePath) {
        Qt.openUrlExternally(fileUtils.pathWithPrefix(fileNamePath))
    }

    function changeTitle(title) {
        titleBar.text = title
    }

    function showPopupMessage(text) {
        popupMessage.body = text
        popupMessage.show()
    }

    function cancelPopupMessage() {
        popupMessage.cancel()
    }

    function setContextMenuItemText(index, text) {
        menu.setContextMenuItemText(index,text)
    }

    function setContextMenuItemState(index,enabled, visible) {
        menu.setContextMenuItemState(index,enabled, visible)
    }

    function showAppMenu(showGlobalMenu) {
        appWindow.menuBar = myMenuBar
        titleBar.overFlowButtonVisible = true
        menu.showGlobalMenu(showGlobalMenu)
    }

    function hideAppMenu() {
        menu.showGlobalMenu(false)
        appWindow.menuBar = null
        titleBar.overFlowButtonVisible = false
    }

    function popTransitionEnded(objectName) {
        console.log( "popTransitionEnded: " + objectName )
        //for (var i = 0; i < stackView.depth; i++) {
        //    var item = stackView.get(i, true )
        //    //console.log( "In stack: " + item.objectName )
        //}
    }

    function gotoPage(page) {
        stackView.push(Qt.resolvedUrl(page))
    }

    function invokeMainPage(typeId, text) {
        stackView.push({item:Qt.resolvedUrl("ListViewPage.qml"), properties:{type:typeId, title:text}})
    }

    function showInfoDialogText(text, additionalInfo) {
        messageDialog.show(text, additionalInfo)
    }
    function showInfoDialog(templateId, additionalInfo) {
        showInfoDialogText(templateId.getDescription(), additionalInfo)
    }

    Rectangle {
        id: backgroundRectangle
        color: "black"
        anchors.fill: parent
    }

    toolBar: MyTitleBar  {
        id: titleBar
    }

    menuBar: MenuBar {
        id: myMenuBar

        Menu {
            id: menu
            title: qsTr("Menu")

            function showGlobalMenu(enable) {
                settingsMenuItem.visible = enable
                myFilesMenuItem.visible = enable
                aboutMenuItem.visible = enable
                separatorMenuItem.visible = enable
                exitMenuItem.visible = enable

                for (var i = 0; i < 10; i++) {
                    var contextMenuItem = findContextMenuItemByIndex(i)
                    contextMenuItem.visible = false
                }
            }

            function findContextMenuItemByIndex(index) {
                var menuItems = menu.items
                for (var i = 0; i < menuItems.length; i++) {
                    if ( menuItems[i].objectName === ("customMenuItem" + index) ) {
                        return menuItems[i]
                    }
                }
            }

            function setContextMenuItemState(index, enable, visible) {
                var menuItem = findContextMenuItemByIndex(index)
                menuItem.visible = visible
                menuItem.enabled = enable
            }

            function setContextMenuItemText(index,text) {
                var menuItem = findContextMenuItemByIndex(index)
                menuItem.text = text
            }

            MenuItem {
                id: myFilesMenuItem
                text: qsTr("My files")
                onTriggered: {
                    hideAppMenu()
                    gotoPage("FileManagerPage.qml")
                }
            }

            MenuItem {
                id: settingsMenuItem
                text: qsTr("Settings")
                onTriggered: {
                    hideAppMenu()
                    gotoPage("SettingsPage.qml")
                }
            }

            MenuItem {
                id: aboutMenuItem
                text: qsTr("About")
                onTriggered: {
                    gotoPage("AboutPage.qml")
                }
            }

            MenuSeparator {
                id: separatorMenuItem
            }

            MenuItem {
                id: exitMenuItem
                text: qsTr("Exit")
                shortcut: StandardKey.Quit

                onTriggered: Qt.quit()
            }

            MenuItem {
                id: customMenuItem0
                objectName: "customMenuItem0"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(0)
                }
            }

            MenuItem {
                id: customMenuItem1
                objectName: "customMenuItem1"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(1)
                }
            }

            MenuItem {
                id: customMenuItem2
                objectName: "customMenuItem2"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(2)
                }
            }

            MenuItem {
                id: customMenuItem3
                objectName: "customMenuItem3"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(3)
                }
            }

            MenuItem {
                id: customMenuItem4
                objectName: "customMenuItem4"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(4)
                }
            }

            MenuItem {
                id: customMenuItem5
                objectName: "customMenuItem5"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(5)
                }
            }

            MenuItem {
                id: customMenuItem6
                objectName: "customMenuItem6"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(6)
                }
            }

            MenuItem {
                id: customMenuItem7
                objectName: "customMenuItem7"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(7)
                }
            }

            MenuItem {
                id: customMenuItem8
                objectName: "customMenuItem8"
                visible: false

                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(8)
                }
            }

            MenuItem {
                id: customMenuItem9
                objectName: "customMenuItem9"
                visible: false
                onTriggered:  {
                    stackView.currentItem.customMenuItemClicked(9)
                }
            }
        }
    }

    Loader {
        id: welcomeLoader
    }

    MyLabel {
        id: dummyLabel
        visible: false
        color: ui.featureColor1
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Info")
        text: ""
        icon: StandardIcon.Information

        property bool fatalError: false

        function show(messageText, titleText) {
            if (fatalError) {
                icon = StandardIcon.Critical
            }
            text = messageText
            title = titleText
            open()
        }

        onAccepted: {
            visible = false
            if (messageDialog.fatalError) {
                Qt.quit()
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        focus: true
        property int stackViewValue: 1

        Keys.onReleased: {
            if (event.key === Qt.Key_Back) {
                if ( stackView.depth > stackViewValue) {
                    stackView.pop()
                    event.accepted = true
                }
            }
        }
        initialItem: MainViewPage {}
    }

    MySystemToast {
        id: popupMessage
        property string body

        function show() {
            displayMessage(body)
        }
    }

    MySystemInputDialog {
        id: mySystemInputDialog
    }
}

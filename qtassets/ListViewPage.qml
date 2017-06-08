import QtQuick 2.6
import QtQuick.Controls 1.4
// Needed for singletons QTBUG-34418
import "."

Item {
    id: backgroundRectangle
    objectName: "ListViewPage"
    width: parent.width
    height: parent.height
    property int type
    property string title

    onVisibleChanged: {
        updateGui()
    }

    Component.onCompleted: {
        updateGui()
    }

    function updateGui() {
        if (visible) {
            appWindow.changeTitle(title)
            appWindow.showAppMenu(true)
        }
    }

    function showInfoDialog(itemId, title) {
        var templateId = null
        if (itemId === templates.reserveredMultiTemplateId()) {
            var i = templates.firstTemplateIdForReserveredMultiTemplateId()
            templateId = templates.templateAtIndex(i)
        } else {
            templateId = templates.templateAtIndex(itemId)
        }
        appWindow.showInfoDialog(templateId, title)
    }

    Rectangle {
        id: rect
        width: (backgroundRectangle.width > ui.maximumPageWidth) ? ui.maximumPageWidth : backgroundRectangle.width
        height: backgroundRectangle.height
        color : "transparent"
        anchors.centerIn: backgroundRectangle
    }

    Menu {
        id: contextMenu
        title: qsTr("Menu")
        property var itemId
        property string itemTitle

        MenuItem {
            id: infoMenuItem
            text: qsTr("Info")
            onTriggered: {
                showInfoDialog(contextMenu.itemId, contextMenu.itemTitle)
            }
        }
    }

    ListView {
        id: listView
        width: rect.width - ui.defautMargin
        height: rect.height
        anchors.centerIn: rect
        model: myListViewModel

        Component.onDestruction: {
            appWindow.popTransitionEnded(objectName)
        }

        delegate: MyListItem {
            text: title
            onClicked: {
                appWindow.hideAppMenu()
                stackView.push( {item:Qt.resolvedUrl(page), properties:{itemId:itemId}})
            }
            onPressAndHold: {
                contextMenu.itemId = itemId
                contextMenu.title = title
                contextMenu.itemTitle = title
                contextMenu.popup()
            }
        }

        MyListViewModel {
            id: myListViewModel
            sortColumnName: "title"
            order: "asc"

            Component.onCompleted: {
                var multiTmplIndexGroup = -1
                for ( var i = 0; i < templates.count(); i++ ) {
                    if (!templates.isHaveGroupIndex(i, backgroundRectangle.type)) {
                        continue
                    }

                    var multiTmplIndex = (templates.isMultiTemplateId(i)) ? i : -1
                    if (multiTmplIndex >= 0) {
                        multiTmplIndexGroup = multiTmplIndex
                    }

                    if ( i !== multiTmplIndex) {
                        append({"title" : templates.itemAtIndex(i, "title"), "itemId" : i, "page" :"ConfigurePage.qml"})
                    }
                }

                if (multiTmplIndexGroup >= 0) {
                    append({"title" :templates.itemAtIndex(multiTmplIndexGroup, "title"), "itemId" : templates.reserveredMultiTemplateId(), "page" :"ConfigurePage.qml"})
                }

                myListViewModel.quick_sort()
            }
        }
    }
}

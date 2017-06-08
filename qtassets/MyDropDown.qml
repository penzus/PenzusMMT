import QtQuick 2.6
import QtQuick.Controls 1.4
// Needed for singletons QTBUG-34418
import "."

Row {
    id: row
    width: parent.width
    spacing: ui.defautRowSpacing

    property alias title: label.text
    property alias selectedIndex: comboBox.currentIndex

    signal currentIndexChanged()
    signal initialized()

    function isInteger(x) {
        return x % 1 === 0;
    }

    function setOptionByValue(value) {
        if (isInteger(value)) {
            comboBox.setOptionByValue(value.toString())
            return
        }
        comboBox.setOptionByValue(value)
    }

    function getOptionByValue() {
        return comboBox.getOptionByValue()
    }

    function appendOption(text, value) {
        listModel.append({"text": text, "value": value} )
    }

    function setSelectedIndex(index) {
        comboBox.currentIndex = index
    }

    MyLabel {
        id: label
        width: parent.width - comboBox.width - row.spacing
        anchors.verticalCenter: row.verticalCenter
    }

    MyComboBox {
        id: comboBox
        anchors.verticalCenter: row.verticalCenter
        model: ListModel {
            id: listModel
            ListElement { text: "Banana"; value: "Yellow" }
        }

        Component.onCompleted: {
            listModel.clear()
            row.initialized()
        }

        onCurrentIndexChanged: {
            row.currentIndexChanged()
        }
    }
}

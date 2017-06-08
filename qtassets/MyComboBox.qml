import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
// Needed for singletons QTBUG-34418
import "."

ComboBox {
    currentIndex: 0

    function getOptionByValue() {
        return model.get(currentIndex).value
    }

    function setOptionByValue(value) {
        for (var i = 0; i < model.count; i++) {
            if (model.get(i).value === value) {
                currentIndex = i
                return
            }
        }
    }

    style: ComboBoxStyle {
        background: Rectangle {
            id: rectCategory

            implicitWidth: ui.defaultComboBoxWidth
            implicitHeight: ui.defaultComboBoxHeight

            radius: ui.defaultComboBoxRadius
            border.width: ui.defaultComboBoxBorderWidth
            color: control.pressed ? "#4d4d4d" : "#2c2c2c"
        }

        label: Text {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            text: control.currentText
        }
    }
}

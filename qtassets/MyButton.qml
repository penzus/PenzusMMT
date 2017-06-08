import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
// Needed for singletons QTBUG-34418
import "."

Button {
    id: button

    style: ButtonStyle {

        background: Rectangle {
            implicitWidth: ui.defautButtonWidth
            implicitHeight: ui.defautButtonHeight
            radius: ui.defautButtonRadius

            gradient: Gradient {
                GradientStop {
                    position: 0;
                    color: {
                        if (!control.enabled) return "#1f1f1f"
                        return control.pressed ? "#505050" : "#313131"
                    }
                }

                GradientStop {
                    position: 1;
                    color: {
                        if (!control.enabled) return "#191919"
                        return control.pressed ? "#474747" : "#282828"
                    }
                }
            }
        }

        label: Label {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: (!control.enabled) ? "#717171" : "#f0f0f0"
            elide: Text.ElideRight
            text: button.text
        }
    }
}

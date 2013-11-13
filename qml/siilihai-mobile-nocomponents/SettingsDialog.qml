import QtQuick 2.0
import "widgets"

SimpleDialog {
    Column {
        width: parent.width
        spacing: 10
        Text {
            text: "Settings"
            color: color_b_text
            font.pointSize: headerPointSize
        }
        SimpleButton {
            text: "Unregister this copy of Siilihai"
            onClicked: siilihaimobile.unregisterSiilihai()
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Item {
            width: 1
            height: 50
        }
        SimpleButton {
            text: "Close"
            onClicked: topItem = false
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

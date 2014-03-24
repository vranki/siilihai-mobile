import QtQuick 2.0
import "widgets"

SimpleDialog {
    Column {
        width: parent.width
        spacing: 10
        Text {
            text: "Settings"
            color: color_b_text
            font.pixelSize: headerPixelSize
        }
        ConfirmationButton {
            text: "Unregister this copy of Siilihai"
            onClicked: siilihaimobile.unregisterSiilihai()
            anchors.horizontalCenter: parent.horizontalCenter
        }
        SimpleCheckBox {
            text: "Developer mode"
            checked: false
            onCheckedChanged: siilihaimobile.developerMode = checked
        }

        Item {
            width: 1
            height: mainItem.height/4
        }
        SimpleButton {
            text: "Close"
            onClicked: topItem = false
            anchors.horizontalCenter: parent.horizontalCenter
            Component.onCompleted: mainItem.backPressed.connect(clicked)
        }
    }
}

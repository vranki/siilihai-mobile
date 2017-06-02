import QtQuick 2.0
import "widgets"

SimpleDialog {
    topItem: true

    ListView {
        id: messageListView
        width: parent.width*0.9
        height: parent.height
        anchors.centerIn: parent
        model: siilihaimobile.errorMessages
        spacing: 20
        delegate: Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: modelData
            color: "white"
            font.pixelSize: largePixelSize
            Rectangle {
                color: "white"
                width: parent.width * 0.3
                height: 1
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                visible: index < parent.count
            }
        }
        footer: Item {
            width: parent.width
            height: 200
            SimpleButton {
                id: closeButton
                anchors.centerIn: parent
                text: "Ok"
                onClicked: siilihaimobile.dismissMessages()
                Component.onCompleted: mainItem.backPressed.connect(clicked)
            }
        }
    }
}

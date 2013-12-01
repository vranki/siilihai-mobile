import QtQuick 2.0
import "widgets"

SimpleDialog {
    property bool shown: errormessages.length > 0
    y: shown ? 0 : parent.height
    Behavior on y { SmoothedAnimation { velocity: 2500; easing.type: Easing.InOutQuad  } }
    ListView {
        anchors.fill: parent
        model: errormessages
        spacing: 20
        delegate: Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: modelData
            color: "white"
            font.pointSize: largePointSize
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
            height: 100
            SimpleButton {
                id: closeButton
                anchors.centerIn: parent
                text: "Ok"
                onClicked: siilihaimobile.dismissMessages()
            }
        }

    }
    onShownChanged: Qt.inputMethod.hide();
}

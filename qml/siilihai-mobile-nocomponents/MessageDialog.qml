import QtQuick 2.0

Rectangle {
    width: parent.width
    height: parent.height
    color: "black"
    y: errormessages.length ? 0 : parent.height
    Behavior on y { SmoothedAnimation { velocity: 2500; easing.type: Easing.InOutQuad  } }
    ListView {
        width: parent.width
        height: parent.height - closeButton.height
        model: errormessages
        delegate: Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: modelData
            color: "white"
            font.pointSize: 20
            Rectangle {
                color: "white"
                width: parent.width * 0.3
                height: 1
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
    SimpleButton {
        id: closeButton
        text: "Ok"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: siilihaimobile.dismissMessages()
    }
}

import QtQuick 2.0
import "widgets"

Rectangle {
    width: parent.width
    height: parent.height
    color: "black"
    objectName: "credentialsDialog"
    property string forumAlias: ""
    y: forumAlias.length > 0 ? 0 : parent.height
    Behavior on y { SmoothedAnimation { velocity: 2500; easing.type: Easing.InOutQuad  } }
    Column {
        Text {
            text: "Enter credentials for " + forumAlias
            font.pointSize: 20
            wrapMode: Text.Wrap
            color: "white"
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

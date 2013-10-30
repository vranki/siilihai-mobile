import QtQuick 2.0
import ".."

Rectangle {
    property bool topItem: false
    x: topItem ? 0 : parent.width
    color: "black"
    width: parent.width
    height: parent.height
    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.height
        Column {
            id: contentColumn
            width: parent.width
            spacing: 25
            Text {
                font.pointSize: 20
                color: "white"
                text: topItem ? selectedforum.alias : ""
            }
            ListView {
                width: parent.width
                height: childrenRect.height
                interactive: false
                spacing: 10
                model: subscribeGroupList
                delegate: GroupSubscriptionButton { }
            }
            SimpleButton {
                text: "Unsubscribe forum"
                width: parent.width / 3
                buttonColor: "red"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    forumSettingsDialog.topItem = false
                    siilihaimobile.unsubscribeCurrentForum()
                }
            }
            SimpleButton {
                text: "Ok"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    siilihaimobile.applyGroupSubscriptions()
                    forumSettingsDialog.topItem = false
                }
            }
        }
    }
}

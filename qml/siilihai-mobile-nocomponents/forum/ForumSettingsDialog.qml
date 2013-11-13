import QtQuick 2.0
import ".."
import "../widgets"

SimpleDialog {
    objectName: "forumSettingsDialog"
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
                text: topItem && selectedforum ? selectedforum.alias : ""
            }
            ListView {
                width: parent.width
                height: childrenRect.height
                interactive: false
                spacing: 10
                model: subscribeGroupList
                delegate: GroupSubscriptionButton { }
            }
            UserPassForm {
                id: authentication
                checked: selectedforum ? selectedforum.isAuthenticated : true
                username: selectedforum ? selectedforum.username : ""
                password: selectedforum ? selectedforum.password : ""
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
                    selectedforum.isAuthenticated = authentication.checked
                    selectedforum.username = authentication.username
                    selectedforum.password = authentication.password
                    siilihaimobile.applyGroupSubscriptions()
                    forumSettingsDialog.topItem = false
                }
            }
        }
    }
}

import QtQuick 2.0
import ".."
import "../widgets"

SimpleDialog {
    objectName: "forumSettingsDialog"
    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.height
        MouseArea { width: parent.width; height: contentColumn.height; onClicked: hideVkb() } // Hax
        Column {
            id: contentColumn
            width: parent.width
            spacing: 25
            Text {
                font.pointSize: headerPointSize
                color: color_b_text
                text: topItem && selectedforum ? selectedforum.alias : ""

            }
            SimpleCheckBox {
                property bool dontShowByDefault: groupList.count > 100
                id: showGroupsCheckbox
                text: "Show all " + groupList.count + " groups"
                checked: !dontShowByDefault
                visible: dontShowByDefault
            }
            ListView {
                id: groupList
                width: parent.width
                height: showGroupsCheckbox.checked ? count * (tallButtonHeight + spacing) + 100 : 0 // Ugly
                Behavior on height { SmoothedAnimation { duration: 1000 } }
                interactive: false
                spacing: 10
                model: subscribeGroupList
                header: Text {
                    font.pointSize: largePointSize
                    color: color_b_text
                    text: count ? "Group subscriptions" : "Getting group list.."
                }
                delegate: GroupSubscriptionButton { }
            }
            UserPassForm {
                id: authentication
                checked: selectedforum ? selectedforum.isAuthenticated : true
                username: selectedforum ? selectedforum.username : ""
                password: selectedforum ? selectedforum.password : ""
            }
            ConfirmationButton {
                text: "Unsubscribe forum"
                width: parent.width / 2
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
                Component.onCompleted: mainItem.backPressed.connect(clicked)
            }
            Item {width: 1; height: mainItem.height/2 } // Spacer
        }
    }
}

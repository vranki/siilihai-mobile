import QtQuick 2.0
import ".."
import "../widgets"

SimpleDialog {
    objectName: "forumSettingsDialog"
    Flickable {
        id: forumSettingsFlickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.height
        MouseArea { width: parent.width; height: contentColumn.height; onClicked: hideVkb() } // Hax
        Column {
            id: contentColumn
            width: parent.width
            spacing: 25
            Text {
                font.pixelSize: headerPixelSize
                color: color_b_text
                text: topItem && selectedforum ? selectedforum.alias : ""
            }
            UserPassForm {
                id: authentication
                checked: selectedforum ? selectedforum.isAuthenticated : true
                username: selectedforum ? selectedforum.username : ""
                password: selectedforum ? selectedforum.password : ""
            }
            ConfirmationButton {
                text: "Unsubscribe"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    forumSettingsDialog.topItem = false
                    siilihaimobile.unsubscribeCurrentForum()
                }
            }
            Text {
                width: parent.width
                x: parent.width/8
                font.pixelSize: largePixelSize
                text: (selectedforum ? selectedforum.unreadCount : "?") + " unread"
                color: color_b_text
            }
            Item {
                width: parent.width
                height: defaultButtonHeight
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: largePixelSize
                    text: "Mark all:"
                    color: color_b_text
                }
                ConfirmationButton {
                    anchors.right: unreadButton.left
                    anchors.rightMargin: 3
                    width: parent.width / 3
                    text: "read"
                    onClicked: selectedforum.markRead()
                }
                ConfirmationButton {
                    id: unreadButton
                    anchors.right: parent.right
                    width: parent.width / 3
                    text: "unread"
                    onClicked: selectedforum.markRead(false)
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
                    groupList.groupFilterString = ""
                }
                Component.onCompleted: mainItem.backPressed.connect(clicked)
            }
            Item {width: 1; height: mainItem.height/8 } // Spacer
            ListView {
                id: groupList
                width: parent.width
                height: count * (tallButtonHeight + spacing) + 300 // Ugly
                interactive: false
                spacing: 0
                property string groupFilterString: ""
                model: subscribeGroupList
                header: Column {
                    width: parent.width
                    Text {
                        font.pixelSize: headerPixelSize
                        color: color_b_text
                        text: groupList.count ? "Group subscriptions" : "Getting groups.."
                    }
                    Text {
                        font.pixelSize: smallPixelSize
                        color: color_b_text
                        text: "Search:"
                    }
                    SimpleTextEdit {
                        clearButton: true
                        onTextChanged: groupList.groupFilterString = text.toLocaleLowerCase()
                    }
                }
                delegate: GroupSubscriptionButton { }
            }
            SimpleButton {
                text: "Back to top"
                onClicked: forumSettingsFlickable.contentY = 0
                visible: groupList.count > 50
            }
            Item {width: 1; height: mainItem.height/2 } // Spacer
        }
    }
}

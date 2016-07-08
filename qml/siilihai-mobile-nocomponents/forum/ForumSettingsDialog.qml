import QtQuick 2.0
import ".."
import "../widgets"

SimpleDialog {
    id: forumSettingsDialog
    objectName: "forumSettingsDialog"
    topItem: true

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
                text: forumListView.selectedForum.alias
            }
            ListView {
                id: errorList
                width: parent.width
                height: count ? (count * (tallButtonHeight + spacing) + 100) : 0 // Ugly
                interactive: false
                model: forumListView.selectedForum.errors
                delegate: UpdateError {}
                Rectangle {
                    anchors.fill: parent
                    color: color_b_error_bg
                    z: -1
                }
            }
            UserPassForm {
                id: authentication
                checked: forumListView.selectedForum.isAuthenticated
                username: forumListView.selectedForum.username
                password: forumListView.selectedForum.password
            }
            ConfirmationButton {
                text: "Unsubscribe"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    forumSettingsDialog.closeLater()
                    groupList.model = undefined // Otherwise it's SLOW
                    siilihaimobile.subscriptionManagement.unsubscribeForum(forumListView.selectedForum)
                }
            }
            Text {
                width: parent.width
                x: parent.width/8
                font.pixelSize: largePixelSize
                text: forumListView.selectedForum.unreadCount + " unread"
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
                    onClicked: forumListView.selectedForum.markRead()
                }
                ConfirmationButton {
                    id: unreadButton
                    anchors.right: parent.right
                    width: parent.width / 3
                    text: "unread"
                    onClicked: forumListView.selectedForum.markRead(false)
                }
            }
            SimpleButton {
                text: "Ok"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    forumListView.selectedForum.clearErrors()
                    forumListView.selectedForum.isAuthenticated = authentication.checked
                    forumListView.selectedForum.username = authentication.username
                    forumListView.selectedForum.password = authentication.password
                    siilihaimobile.updateGroupSubscriptions(forumListView.selectedForum)
                    forumSettingsDialog.closeDialog()
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
                model: forumListView.selectedForum.groups
                header: Column {
                    width: parent.width
                    Text {
                        font.pixelSize: 0
                        color: color_b_text
                        text: groupList.count ? "Group subscriptions" : "No known groups"
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

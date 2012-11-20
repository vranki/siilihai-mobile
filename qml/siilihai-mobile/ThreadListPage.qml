import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    property string groupname: "?"

    ListView {
        anchors.fill: parent
        model: threads

        header: Row {
            Image {
                source: groupListPage.forumIcon
                width: height
                height: 32
                z: -10
                anchors.verticalCenter: forumNameLabel.Center
            }
            Label {
                id: forumNameLabel
                text: groupname;
                wrapMode: Text.Wrap
                anchors.leftMargin: 10
            }
        }

        delegate: Row {
            ButtonWithUnreadCount {
                label: displayName
                unreads: unreadCount
                icon: unreads > 0 ? "folder-new.png" : "folder.png"
                onClicked:  {
                    appWindow.threadSelected(id)
                    messageListPage.hasMoreMessages = hasMoreMessages
                    messageListPage.threadname = displayName
                    appWindow.pageStack.push(messageListPage)
                }
            }
        }
    }
}

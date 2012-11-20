import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent
    property string forumname: "?"
    property string forumIcon: ""

    ListView {
        anchors.fill: parent
        model: groups
        spacing: 5
        header: Row {
            Image {
                source: forumIcon
                width: height
                height: 32
                z: -10
                anchors.verticalCenter: forumNameLabel.Center
            }
            Label {
                id: forumNameLabel
                text: forumname;
                wrapMode: Text.Wrap
                anchors.leftMargin: 10
            }
        }

        delegate: Row {
            ButtonWithUnreadCount {
                label: name
                unreads: unreadCount
                icon: unreads > 0 ? "folder-new.png" : "folder.png"
                onClicked:  {
                    threadListPage.groupname = name
                    appWindow.groupSelected(id)
                    appWindow.pageStack.push(threadListPage)
                }
            }
        }
        footer: Button {
            text: "Manage Subscriptions"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: appWindow.subscribeGroups()
        }
    }
}

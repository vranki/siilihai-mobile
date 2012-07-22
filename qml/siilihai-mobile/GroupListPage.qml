import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent
    property string forumname: "?"

    ListView {
        anchors.fill: parent
        model: groups

        header: Label {
            text: "Groups in " + forumname;
            color: "white"
            wrapMode: Text.Wrap
        }

        delegate: Row {
            ButtonWithUnreadCount {
                label: name
                unreads: unreadCount
                onClicked:  {
                    threadListPage.groupname = name
                    appWindow.groupSelected(id)
                    appWindow.pageStack.push(threadListPage)
                }
            }
        }
        footer: Button {
            text: "Manage Subscriptions"
            onClicked: appWindow.subscribeGroups()
        }
    }
}

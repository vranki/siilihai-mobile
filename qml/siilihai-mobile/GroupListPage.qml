import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent

    ListView {
        anchors.fill: parent
        model: groups
        delegate: Row {
            ButtonWithUnreadCount {
                text: name
                unreads: unreadCount
                onClicked:  {
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

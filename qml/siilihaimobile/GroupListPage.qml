import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent

    ListView {
        anchors.fill: parent
        model: groups
        delegate: Row {
            Button {
                text: id + ": " + name + " (" + unreadCount + ")"
                width: groupListPage.width
                onClicked:  {
                    appWindow.groupSelected(id)
                    appWindow.pageStack.push(threadListPage)
                    console.log("grp selected " + id)
                }
            }
        }
        footer: Button {
            text: "Manage Subscriptions"
            onClicked: appWindow.subscribeGroups()
        }
    }
}

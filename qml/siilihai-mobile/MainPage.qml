import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    ListView {
        anchors.fill: parent
        model: subscriptions
        header: Text {
            text: "Forums";
            color: "white"
        }
        delegate: Row {
            ButtonWithUnreadCount {
                text: alias
                unreads: unreadCount
                onClicked:  {
                    appWindow.subscriptionSelected(parser)
                    appWindow.pageStack.push(groupListPage)
                }
            }
        }
        footer: Button {
            anchors.topMargin: 20
            text: "Subscribe new.."
            onClicked: appWindow.showSubscribeWizard()
        }
    }
}

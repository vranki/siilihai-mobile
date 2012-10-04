import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    property bool busy: true
    property string message: ""

    tools: commonTools
    ListView {
        anchors.fill: parent
        model: subscriptions
        header: Column {
            width: parent.width
            Label {
                text: "Subscribed Forums";
                wrapMode: Text.Wrap
            }
            ProgressBar {
                indeterminate: true
                width: parent.width
                visible: mainPage.busy
            }
            Label {
                id: statusmessage
                text: mainPage.message
                font.italic: true
            }
        }
        delegate: Row {
            ButtonWithUnreadCount {
                label: alias
                unreads: unreadCount
                busy: beingUpdated || beingSynced || scheduledForUpdate
                onClicked:  {
                    groupListPage.forumname = alias
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

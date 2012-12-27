import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    property bool busy: true
    property string message: ""

    tools: commonTools
    ListView {
        anchors.fill: parent
        model: subscriptions
        spacing: 5
        header: Column {
            width: parent.width
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
                icon: faviconUrl.length > 0 ? faviconUrl : "emblem-web.png"
                onClicked:  {
                    groupListPage.forumname = alias
                    groupListPage.forumIcon = icon
                    appWindow.subscriptionSelected(forumId)
                    appWindow.pageStack.push(groupListPage)
                }
            }
        }
        footer: Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Subscribe new.."
            onClicked: appWindow.showSubscribeWizard()
        }
    }
}

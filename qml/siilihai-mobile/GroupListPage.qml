import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    anchors.fill: parent
    property string forumname: "?"
    property string forumIcon: ""
    tools: commonTools

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
        footer: Column {
            Button {
                text: "Manage Subscriptions"
                onClicked: appWindow.subscribeGroups()
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: "Unsubscribe"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: confirmUnsubscribeDialog.open()
            }
        }
    }
    Dialog {
        id: confirmUnsubscribeDialog
        content: Label {
            text: "Really unsubscribe from forum?"
            width: parent.width
            anchors.centerIn: parent
            wrapMode: Text.Wrap
            color: "white"
        }
        buttons: ButtonRow {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30
            anchors.top: errorLabel.Bottom
            Button {text: "Yes"; onClicked: confirmUnsubscribeDialog.accept()}
            Button {text: "No"; onClicked: confirmUnsubscribeDialog.reject()}
          }
        onAccepted: {
            pageStack.pop()
            appWindow.unSubscribeCurrentForum()
        }
    }
}

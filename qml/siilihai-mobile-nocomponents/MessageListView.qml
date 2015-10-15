import QtQuick 2.0
import "widgets"

ListView {
    width: parent.width * 0.9
    height: parent.height
    spacing: 10
    model: parent.model

    function gotoIndex(idx) {
        var pos = contentY;
        var destPos;
        messageListView.positionViewAtIndex(idx, ListView.Center);
        destPos = contentY;
        anim.from = pos;
        anim.to = destPos;
        anim.running = true;
    }
    NumberAnimation { id: anim; target: messageListView; property: "contentY"; easing.type: Easing.InOutQuad; duration: 500; onStopped: returnToBounds() }

    header: Column {
        width: parent.width * 0.95
        spacing: 5
        ThreadButton {
            text: selectedThread.displayName
            rightText: selectedThread.unreadCount
            smallText: threadListView.selectedGroup.displayName + " - " + forumListView.selectedForum.alias
            hmm: selectedThread.hasMoreMessages
            icon: selectedThread.unreadCount > 0 ? "gfx/Gnome-mail-unread.svg" : "gfx/Gnome-mail-read.svg"
            width: parent.width * 0.95
            z: -10
            anchors.horizontalCenter: parent.horizontalCenter
            drawBorder: false
            enableClickAnimation: false
        }
        SimpleButton {
            text: "Show first unread"
            buttonColor: color_a_text
            anchors.horizontalCenter: parent.horizontalCenter
            visible: selectedThread.unreadCount
            onClicked: {
                for(var i=0;i<count;i++) {
                    if(!model[i].isRead) {
                        gotoIndex(i);
                        return;
                    }
                }
            }
        }
        Item {width: 1; height: defaultButtonHeight}
    }
    delegate: MessageDisplay {
        width: parent.width * 0.98
        anchors.horizontalCenter: parent.horizontalCenter
    }
    footer: Column {
        width: parent.width * 0.82
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Item {
            width: 1
            height: 50
        }
        SimpleButton {
            text: "Get more messages"
            visible: selectedThread.hasMoreMessages
            buttonColor: color_a_text
            enabled: visible && !forumListView.selectedForum.beingUpdated
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: siilihaimobile.showMoreMessages()
        }
        SimpleButton {
            text: "Mark all read"
            buttonColor: color_a_text
            onClicked: markAll(true)
            anchors.horizontalCenter: parent.horizontalCenter
            icon: "gfx/Gnome-mail-mark-read.svg"
            visible: messageListView.selectedThread.unreadCount
        }
        SimpleButton {
            text: "Mark all unread"
            buttonColor: color_a_text
            onClicked: markAll(false)
            anchors.horizontalCenter: parent.horizontalCenter
            icon: "gfx/Gnome-mail-mark-unread.svg"
            visible: (count - messageListView.selectedThread.unreadCount)
        }
        /*
        SimpleButton {
            buttonColor: color_a_text
            text: "Reply..";
            visible: forumListView.selectedforum && forumListView.selectedforum.supportsPosting && forumListView.selectedforum.isAuthenticated
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                composeMessage.newMessage()
                composeMessage.setSubject(siilihaimobile.addReToSubject(selectedthread.name))
                composeMessage.appendBody(siilihai.settings.signature)
                composeMessage.groupId = selectedgroup.id
                composeMessage.threadId = selectedthread.id
            }
        }
        */
        Item {
            width: 1
            height: mainItem.height/2
        }
    }

    ButtonWithUnreadCount {
        anchors.fill: parent
        z: -10
        enableClickAnimation: false
    }
    function markAll(r) {
        for(var i=0;i<count;i++) {
            model[i].isRead = r
        }
    }
}

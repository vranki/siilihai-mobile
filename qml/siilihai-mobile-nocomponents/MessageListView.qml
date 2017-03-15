import QtQuick 2.0
import "widgets"

ListView {
    width: parent ? parent.width * 0.9 : 0
    height: parent ? parent.height : 0
    spacing: 10
    model: parent ? parent.model : 0

    function gotoIndex(idx) {
        var pos = contentY
        console.log("Old pos", contentY)
        var destPos
        messageListView.item.positionViewAtIndex(idx, ListView.Center)
        destPos = contentY
        console.log("Destination pos", destPos)
        anim.from = pos
        anim.to = destPos
        anim.running = true
    }
    Connections {
        target: mainItem
        onBackPressed: {
            messageListView.selectedThread = undefined
            messageListView.active = false
        }
    }

    NumberAnimation on contentY {
        id: anim
        easing.type: Easing.InOutQuad
        duration: 500
        onStopped: returnToBounds()
    }

    header: Column {
        width: parent.width * 0.95
        spacing: 5
        ThreadButton {
            text: selectedThread ? selectedThread.displayName : 0
            rightText: selectedThread ? selectedThread.unreadCount : 0
            smallText: threadListView.selectedGroup.displayName + " - " + forumListView.selectedForum.alias
            hmm: selectedThread ? selectedThread.hasMoreMessages : false
            icon: selectedThread && selectedThread.unreadCount > 0 ? "gfx/Gnome-mail-unread.svg" : "gfx/Gnome-mail-read.svg"
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
            visible: selectedThread ? selectedThread.unreadCount : 0
            onClicked: {
                for(var i=0;i<count;i++) {
                    if(!model[i].isRead) {
                        console.log("First unread is ", i)
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
            visible: selectedThread ? selectedThread.hasMoreMessages : false
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
            icon: "../gfx/Gnome-mail-mark-read.svg"
            visible: selectedThread ? selectedThread.unreadCount : false
        }
        SimpleButton {
            text: "Mark all unread"
            buttonColor: color_a_text
            onClicked: markAll(false)
            anchors.horizontalCenter: parent.horizontalCenter
            icon: "../gfx/Gnome-mail-mark-unread.svg"
            visible: selectedThread ? (count - selectedThread.unreadCount) : false
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

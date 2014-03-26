import QtQuick 2.0
import "widgets"

ListView {
    width: parent.width * 0.9
    height: contentHeight
    spacing: 10
    model: messages
    header: ThreadButton {
        text: selectedthread ? selectedthread.displayName : "no thread"
        rightText: selectedthread ? selectedthread.unreadCount : "no threas"
        smallText: selectedgroup ? selectedgroup.displayName + " - " + selectedforum.alias : ""
        hmm: selectedthread ? selectedthread.hasMoreMessages : false
        icon: selectedthread !== null ? (selectedthread.unreadCount > 0 ? "gfx/Gnome-mail-unread.svg" : "gfx/Gnome-mail-read.svg") : ""
        width: parent.width * 0.95
        z: -10
        anchors.horizontalCenter: parent.horizontalCenter
        drawBorder: false
        enableClickAnimation: false
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
            visible: selectedthread !== null ? selectedthread.hasMoreMessages : false
            buttonColor: color_a_text
            enabled: visible && !selectedforum.beingUpdated
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: siilihaimobile.showMoreMessages()
        }
        SimpleButton {
            text: "Mark all read"
            buttonColor: color_a_text
            onClicked: markAll(true)
            anchors.horizontalCenter: parent.horizontalCenter
            icon: "gfx/Gnome-mail-mark-read.svg"
        }
        SimpleButton {
            text: "Mark all unread"
            buttonColor: color_a_text
            onClicked: markAll(false)
            anchors.horizontalCenter: parent.horizontalCenter
            icon: "gfx/Gnome-mail-mark-unread.svg"
        }
        SimpleButton {
            buttonColor: color_a_text
            text: "Reply..";
            visible: selectedforum && selectedforum.supportsPosting && selectedforum.isAuthenticated
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                composeMessage.newMessage()
                composeMessage.setSubject(siilihaimobile.addReToSubject(selectedthread.name))
                composeMessage.appendBody(siilihaisettings.signature)
                composeMessage.groupId = selectedgroup.id
                composeMessage.threadId = selectedthread.id
            }
        }
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

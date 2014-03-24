import QtQuick 2.0

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
        width: parent.width * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Item {
            width: 1
            height: 50
        }
        ButtonWithUnreadCount {
            text: "Download more messages"
            visible: selectedthread !== null ? selectedthread.hasMoreMessages : false
            onClicked: siilihaimobile.showMoreMessages()
        }
        ButtonWithUnreadCount {
            text: "Mark all read"
            onClicked: markAll(true)
            icon: "gfx/Gnome-mail-mark-read.svg"
        }
        ButtonWithUnreadCount {
            text: "Mark all unread"
            onClicked: markAll(false)
            icon: "gfx/Gnome-mail-mark-unread.svg"
        }
        Item {
            width: 1
            height: toolbar.height
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

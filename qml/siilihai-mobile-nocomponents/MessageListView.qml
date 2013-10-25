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
        icon: selectedforum.faviconUrl
        width: parent.width * 0.95
        z: -10
        anchors.horizontalCenter: parent.horizontalCenter
        drawBorder: false
    }
    delegate: MessageDisplay {
        width: parent.width * 0.98
        anchors.horizontalCenter: parent.horizontalCenter
    }

    footer: Column {
        width: parent.width * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
//        height: UiButton.uiButtonHeight
        UiButton {
            text: "Mark all read"
            onClicked: markAll(true)
        }
        UiButton {
            text: "Mark all unread"
            onClicked: markAll(false)
        }
    }
    UiButton {
        anchors.fill: parent
        z: -10
    }
    function markAll(r) {
        for(var i=0;i<count;i++) {
            model[i].isRead = r
        }
    }
}

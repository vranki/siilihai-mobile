import QtQuick 2.0
import "widgets"

ListView {
    width: parent ? parent.width * 0.9 : 0
    height: parent ? parent.height : 0
    spacing: 10
    model: parent ? parent.model : undefined

    // Copypaste from MessageListView, meh!
    function gotoIndex(idx) {
        var pos = contentY;
        var destPos;
        positionViewAtIndex(idx, ListView.Center);
        destPos = contentY;
        anim.from = pos;
        anim.to = destPos;
        anim.running = true;
    }

    NumberAnimation { id: anim; target: parent; property: "contentY"; easing.type: Easing.InOutQuad; duration: 500 }

    Connections {
        target: mainItem
        onBackPressed: {
            if(!messageListView.active) {
                threadListView.selectedGroup = undefined
                threadListView.active = false
            }
        }
    }

    header: GroupButton {
        text: selectedGroup ? selectedGroup.displayName : ""
        rightText: selectedGroup ? selectedGroup.unreadCount : 0
        smallText: selectedGroup ? selectedGroup.hierarchy : 0
        width: parent.width * 0.95
        z: -10
        anchors.horizontalCenter: parent.horizontalCenter
        drawBorder: false
        icon: "gfx/Gnome-folder-open.svg"
        enableClickAnimation: false
    }
    delegate: ThreadButton {}
    footer: Column {
        width: parent.width
        Item { width: 1; height: defaultButtonHeight}

        SimpleButton {
            anchors.horizontalCenter: parent.horizontalCenter
            buttonColor: color_a_text
            text: "New thread..";
            visible: forumListView.selectedForum && forumListView.selectedForum.supportsPosting && forumListView.selectedForum.isAuthenticated
            onClicked: {
                composeMessage.newMessage()
                composeMessage.appendBody(siilihai.settings.signature)
                composeMessage.groupId = selectedgroup.id
            }
        }

        Item { width: 1; height: mainItem.height / 3}
    }

    ButtonWithUnreadCount {
        anchors.fill: parent
        z: -10
        enableClickAnimation: false
    }
    clip: true
}

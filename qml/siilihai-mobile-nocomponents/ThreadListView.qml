import QtQuick 2.0
import "widgets"

ListView {
    width: parent.width * 0.9
    height: contentHeight
    spacing: 10
    model: threads

    // Copypaste from MessageListView, meh!
    function gotoIndex(idx) {
        var pos = contentY;
        var destPos;
        threadListView.positionViewAtIndex(idx, ListView.Center);
        destPos = contentY;
        anim.from = pos;
        anim.to = destPos;
        anim.running = true;
    }
    NumberAnimation { id: anim; target: threadListView; property: "contentY"; easing.type: Easing.InOutQuad; duration: 500 }

    header: GroupButton {
        text: selectedgroup ? selectedgroup.displayName : "no group"
        rightText: selectedgroup ? selectedgroup.unreadCount : "no group"
        smallText: selectedgroup ? selectedgroup.hierarchy : "no group"
        width:parent.width * 0.95
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
            visible: selectedforum && selectedforum.supportsPosting && selectedforum.isAuthenticated
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

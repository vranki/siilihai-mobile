import QtQuick 2.0
import "widgets"

ListView {
    width: parent.width * 0.9
    height: contentHeight
    spacing: 10
    model: threads
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
            onClicked: {
                composeMessage.newMessage()
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

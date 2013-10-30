import QtQuick 2.0

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
    }
    delegate: ThreadButton {}
    footer: Item {width: 1; height: 50}
    ButtonWithUnreadCount {
        anchors.fill: parent
        z: -10
    }
}

import QtQuick 2.0

ButtonWithUnreadCount {
    property bool hmm: hasMoreMessages
    text: displayName
    rightText: unreadCount
    width: parent.width * 0.95
    anchors.horizontalCenter: parent.horizontalCenter
    onClicked: siilihaimobile.selectThread(id)
    clip: true
    icon: unreadCount > 0 ? "gfx/Gnome-mail-unread.svg" : "gfx/Gnome-mail-read.svg"
    Text {
        text: "+"
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.right: parent.right
        anchors.rightMargin: 1
        font.pointSize: 14
        style: Text.Outline
        color: "white"
        styleColor: "black"
        visible: hmm
        opacity: 0.7
    }
}

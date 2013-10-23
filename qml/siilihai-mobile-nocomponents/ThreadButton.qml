import QtQuick 2.0

UiButton {
    text: displayName
    rightText: unreadCount
    width: parent.width * 0.95
    anchors.horizontalCenter: parent.horizontalCenter
    onClicked: siilihaimobile.selectThread(id)
}

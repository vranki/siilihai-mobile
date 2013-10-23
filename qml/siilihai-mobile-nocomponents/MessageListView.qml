import QtQuick 2.0

ListView {
    width: parent.width * 0.9
    height: contentHeight
    spacing: 10
    model: messages
    header: ThreadButton {
        text: selectedthread ? selectedthread.displayName : "no thread"
        rightText: selectedthread ? selectedthread.unreadCount : "no threas"
        height: uiButtonHeight*2
        width:parent.width * 0.95
        z: -10
        anchors.horizontalCenter: parent.horizontalCenter
        drawBorder: false
    }
    delegate: MessageDisplay {}

    UiButton {
        anchors.fill: parent
        z: -10
    }
}

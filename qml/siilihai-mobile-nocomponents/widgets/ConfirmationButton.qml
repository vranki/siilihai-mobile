import QtQuick 2.0

SimpleButton {
    property string origText: text
    buttonColor: "#ff8888"
    MouseArea {
        anchors.fill: parent
        preventStealing: true
        onPressed: {
            hintText.visible = true
            origText = text
            text = "Hold to confirm"
        }
        onPressAndHold: {
            hintText.visible = false
            text = origText
            parent.clicked(mouse)
        }
        onReleased: {
            hintText.visible = false
            text = origText
        }
        onExited: {
            hintText.visible = false
            text = origText
        }
    }
    Text {
        id: hintText
        color: buttonColor
        anchors.centerIn: parent
        visible: false
    }
}

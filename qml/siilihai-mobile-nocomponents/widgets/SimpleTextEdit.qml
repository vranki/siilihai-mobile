import QtQuick 2.0

TextInput {
    property bool clearButton: false
    color: color_input
    font.pixelSize: headerPixelSize
    width: parent.width * 0.9
    anchors.horizontalCenter: parent.horizontalCenter
    wrapMode: TextEdit.WrapAnywhere
    Rectangle {
        anchors.fill: parent
        color: color_input
        z: -10
        opacity: 0.5
    }
    SimpleButton {
        width: parent.height
        height: width
        anchors.right: parent.right
        text: "x"
        onClicked: parent.text = ""
        visible: clearButton
    }
}

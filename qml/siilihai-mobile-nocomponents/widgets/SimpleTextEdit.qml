import QtQuick 2.0

TextInput {
    property bool clearButton: false
    color: color_input
    font.pixelSize: headerPixelSize
    width: parent.width * 0.9
    anchors.horizontalCenter: parent.horizontalCenter
    focus: false
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

    // For unknown reason Sailfish sets focus on one of the
    // TextEdit's to true causing virtual kb to open at
    // start. This is to prevent it (until smarter fix is found)
    Component.onCompleted: {
        if(focus) {
//            console.log("WTF, why is my focus TRUE??")
            focus = false
        }
    }
}

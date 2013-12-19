import QtQuick 2.0

TextEdit {
    color: "yellow"
    font.pointSize: 15
    width: parent.width * 0.9
    anchors.horizontalCenter: parent.horizontalCenter
    focus: false
    Rectangle {
        anchors.fill: parent
        color: "yellow"
        z: -10
        opacity: 0.5
    }

    // For unknown reason Sailfish sets focus on one of the
    // TextEdit's to true causing virtual kb to open at
    // start. This is to prevent it (until smarter fix is found)
    Component.onCompleted: {
        if(focus) {
            console.log("WTF, why is my focus TRUE??")
            focus = false
        }
    }
}

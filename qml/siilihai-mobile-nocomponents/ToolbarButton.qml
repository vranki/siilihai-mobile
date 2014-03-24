import QtQuick 2.0

Rectangle {
    property string image: ""
    property string text: ""
    signal clicked

    gradient: Gradient {
        GradientStop { position: 0.0; color: "gray" }
        GradientStop { position: 0.1; color: "white" }
        GradientStop { position: 0.9; color: "white" }
        GradientStop { position: 1.0; color: "gray" }
    }

    height: parent.height
    width: height
    radius: 5
    scale: 0.9
    Image {
        anchors.centerIn: parent
        source: parent.image
    }
    Text {
        text: parent.text
        font.pixelSize: 25
        anchors.centerIn: parent
    }
    SequentialAnimation on opacity {
        id: clickOpacityAnimation
        running: false
        NumberAnimation { from: 0.3; to: 1 }
    }
    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: parent.clicked()
        onPressed: clickOpacityAnimation.restart()
    }
}

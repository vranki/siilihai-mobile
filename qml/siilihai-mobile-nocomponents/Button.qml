import QtQuick 1.1

Rectangle {
    id: button
    property string text
    signal clicked
    anchors.fill: textContent
    Text {
        id: textContent
        text: parent.text
    }
    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
    }
}

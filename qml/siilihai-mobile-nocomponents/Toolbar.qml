import QtQuick 2.0

Rectangle {
    width: parent.width
    height: 80
    color: "black"
    Row {
        anchors.fill: parent
        ToolbarButton {
            text: "R"
            onClicked: siilihaimobile.reloadUi()
        }
    }
}

import QtQuick 2.0

Rectangle {
    width: parent.width
    height: 80
    color: "black"
    Row {
        anchors.fill: parent
        ToolbarButton {
            text: "⇐"
            visible: siilihaimobile.selectedGroupId != "" || siilihaimobile.selectedThreadId != ""
            onClicked: {
                if(siilihaimobile.selectedThreadId) {
                    siilihaimobile.selectedThreadId = ""
                } else {
                    siilihaimobile.selectedGroupId = ""
                }
            }
        }
        ToolbarButton {
            text: "R"
            onClicked: siilihaimobile.reloadUi()
        }
    }
}

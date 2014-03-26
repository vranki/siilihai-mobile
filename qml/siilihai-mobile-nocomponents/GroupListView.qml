import QtQuick 2.0

ListView {
    interactive: false
    width: parent.width * 0.9
    height: contentHeight
    spacing: 10
    model: groups
    delegate: GroupButton {
        onClicked: siilihaimobile.selectGroup(id)
    }
}

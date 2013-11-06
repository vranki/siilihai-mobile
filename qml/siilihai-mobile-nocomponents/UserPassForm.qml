import QtQuick 2.0
import "widgets"

Column {
    property string actionLabel: "Ok"
    property alias username: username.text
    property alias password: password.text
    property bool hasValues: username.text.length > 2 && password.text.length > 3
    width: parent.width
    height: childrenRect.height

    Text {
        text: "Username"
        color: "white"
        font.pointSize: 15
    }
    SimpleTextEdit {
        id: username
        focus: true
        inputMethodHints: Qt.ImhNoAutoUppercase
    }
    Text {
        text: "Password"
        color: "white"
        font.pointSize: 15
    }
    SimpleTextEdit {
        id: password
        inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoAutoUppercase
    }
}

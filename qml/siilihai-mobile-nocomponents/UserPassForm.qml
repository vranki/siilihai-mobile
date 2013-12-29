import QtQuick 2.0
import "widgets"

Column {
    property string actionLabel: "Ok"
    property alias username: username.text
    property alias password: password.text
    property bool hasValues: username.text.length > 2 && password.text.length > 3
    property bool optional: true
    property alias checked: check.checked
    property string questionText: "Authenticate?"

    width: parent.width
    height: childrenRect.height

    SimpleCheckBox {
        text: questionText
        id: check
        checked: true
        onCheckedChanged: if(!checked) { username.text = ""; password.text = ""; hideVkb(); }
        width: parent.width
        visible: optional
    }
    Text {
        text: "Username"
        color: color_b_text
        font.pointSize: 15
        opacity: check.checked ? 1 : 0.3
    }
    SimpleTextEdit {
        id: username
        focus: true
        inputMethodHints: Qt.ImhNoAutoUppercase
        opacity: check.checked ? 1 : 0.3
        enabled: check.checked
    }
    Text {
        text: "Password"
        color: color_b_text
        font.pointSize: 15
        opacity: check.checked ? 1 : 0.3
    }
    SimpleTextEdit {
        id: password
        inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoAutoUppercase
        opacity: check.checked ? 1 : 0.3
        enabled: check.checked
    }
    function reset() {
        username.text = ""
        password.text = ""
    }
}

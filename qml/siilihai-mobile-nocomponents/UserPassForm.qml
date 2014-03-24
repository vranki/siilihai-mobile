import QtQuick 2.0
import "widgets"

Item {
    property string actionLabel: "Ok"
    property alias username: username.text
    property alias password: password.text
    property bool hasValues: username.text.length > 2 && password.text.length > 3
    property bool optional: true
    property alias checked: check.checked
    property string questionText: "Authenticate?"

    width: parent.width*0.9
    height: contentColumn.childrenRect.height
    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle {
        color: color_b_text
        anchors.fill: parent
        z: -10
        radius: 3
        opacity: 0.2
    }

    Column {
        id: contentColumn
        width: parent.width
        height: parent.height
        spacing: 10
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
            font.pixelSize: largePixelSize
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
            font.pixelSize: largePixelSize
            opacity: check.checked ? 1 : 0.3
        }
        SimpleTextEdit {
            id: password
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoAutoUppercase
            opacity: check.checked ? 1 : 0.3
            enabled: check.checked
        }
        Item {width:1; height: 10}
    }
    function reset() {
        username.text = ""
        password.text = ""
    }
}

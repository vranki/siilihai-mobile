import QtQuick 1.0
Component {
    Item {
        Column {
            Text {
                text: sub + " (" + msgAuthor + ")"
            }
            Text {
                text: msgBody
                font.pointSize: 8
            }
        }
    }
}

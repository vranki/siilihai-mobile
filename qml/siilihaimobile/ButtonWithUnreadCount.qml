// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Button {
    id: button
    property string label: "?"
    property int unreads: -1
    text: ""
    width: mainPage.width
    height: buttonText.height + 30
    Text {
        anchors.verticalCenter: button.verticalCenter
        anchors.leftMargin: 25
        id: buttonText
        wrapMode: Text.Wrap
        color: "white"
        text: button.label
        width: button.width - button.width/5
    }
    Rectangle {
        id: separator
        width: 2
        height: button.height * 0.8
        anchors.left: buttonText.right
        anchors.top: buttonText.top
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#000000"
            }
            GradientStop {
                position: 0.2
                color: "#FFFFFF"
            }
            GradientStop {
                position: 0.8
                color: "#FFFFFF"
            }
            GradientStop {
                position: 1.0
                color: "#000000"
            }
        }
    }
    Text {
        id: unreadText
        color: "white"
        text: button.unreads
        anchors.left: separator.right
        anchors.top: buttonText.top
        width: button.width - buttonText.width
        height: buttonText.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}

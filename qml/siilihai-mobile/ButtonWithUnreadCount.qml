// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Button {
    id: button
    property string label: ""
    property int unreads: -1
    property bool busy: false
    text: ""
    width: mainPage.width
    height: buttonText.height + 30
    BusyIndicator {
        id: busyindicator
        anchors.left: button.left
        anchors.verticalCenter: button.verticalCenter
        running: button.busy
        anchors.leftMargin: 5
        anchors.rightMargin: 3
        visible: running
    }
    Text {
        font.pointSize: button.font.pointSize
        anchors.verticalCenter: button.verticalCenter
        anchors.left: busyindicator.right
        id: buttonText
        wrapMode: Text.Wrap
        color: "white"
        text: button.label
        width: button.width - busyindicator.width - separator.width - unreadText.width
        verticalAlignment: Text.AlignVCenter
        font.bold: unreads > 0
    }
    Rectangle {
        id: separator
        width: 2
        height: button.height * 0.9
        anchors.right: unreadText.left
        anchors.rightMargin: 5
        anchors.verticalCenter: button.verticalCenter
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
        font.pointSize: button.font.pointSize
        text: button.unreads
        anchors.right: button.right
        anchors.top: buttonText.top
        width: button.width / 8
        height: buttonText.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: unreads > 0
    }
}

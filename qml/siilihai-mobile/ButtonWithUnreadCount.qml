// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Button {
    id: button
    property string label: ""
    property string icon: ""
    property string errorIcon: "emblem-web.png"
    property int unreads: 0
    property bool busy: false
    property bool moreAvailable: false
    width: mainPage.width
    height: buttonText.height + 30
    BusyIndicator {
        id: busyindicator
        running: button.busy
        visible: running
        anchors.fill: iconImage
        z: 100
    }
    Image {
        id: iconImage
        source: icon
        anchors.left: button.left
        anchors.verticalCenter: button.verticalCenter
        width: 32
        height: 32
        anchors.leftMargin: 5
        onStatusChanged: {
            if(status == Image.Error)
                source = errorIcon
        }
    }

    Label {
        font.pointSize: button.font.pointSize
        anchors.verticalCenter: button.verticalCenter
        anchors.left: busyindicator.right
        id: buttonText
        wrapMode: Text.Wrap
        anchors.leftMargin: 5
        text: button.label
//        text: iconImage.source
        width: button.width - busyindicator.width - separator.width - unreadText.width
        verticalAlignment: Text.AlignVCenter
        font.bold: unreads > 0
    }
    Rectangle {
        id: separator
        visible: unreadText.visible
        width: 2
        height: button.height * 0.9
        anchors.right: unreadText.left
        anchors.rightMargin: 2
        anchors.verticalCenter: button.verticalCenter
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#FFFFFF"
            }
            GradientStop {
                position: 0.2
                color: "#888888"
            }
            GradientStop {
                position: 0.8
                color: "#666666"
            }
            GradientStop {
                position: 1.0
                color: "#FFFFFF"
            }
        }
    }
    Label {
        id: unreadText
        font.pointSize: button.font.pointSize/2
        text: button.unreads.toString() + (moreAvailable ? "+" : "")
        visible: button.unreads > 0 || moreAvailable
        anchors.right: button.right
        anchors.top: buttonText.top
        width: button.width / 10
        height: buttonText.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: unreads > 0
    }
}

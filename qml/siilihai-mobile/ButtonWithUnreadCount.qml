// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: button
    property string text: "?"
    property int unreads: -1
    signal clicked
    width: mainPage.width
    height: buttonText.height + 30
    radius: 10
    smooth: true

    Text {
        id: buttonText
        wrapMode: Text.Wrap
        color: "white"
        text: button.text
        width: button.width - button.width/5
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: unreadText
        color: "white"
        text: button.unreads
        anchors.left: buttonText.right
        anchors.top: buttonText.top
        width: button.width - buttonText.width
        height: buttonText.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        color: "white"
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

    MouseArea {
        anchors.fill: button
        onClicked: button.clicked()
    }

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "#555555"
        }
        GradientStop {
            position: 0.2
            color: "#000000"
        }
        GradientStop {
            position: 0.8
            color: "#000000"
        }
        GradientStop {
            position: 1.0
            color: "#000000"
        }
    }
}

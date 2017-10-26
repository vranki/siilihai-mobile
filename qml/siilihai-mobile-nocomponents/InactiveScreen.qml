import QtQuick 2.0

Rectangle {
    property int busyforums: 0
    property int totalforums: siilihai.forumDatabase.subscriptions.length
    visible: Qt.application.state !== Qt.ApplicationActive
    anchors.fill: parent

    gradient: Gradient {
        GradientStop {
            position: 0;
            color: "#71c2ff";
        }
        GradientStop {
            position: 1;
            color: "#646464";
        }
    }

    Image {
        source: "gfx/siilis3.png"
        anchors.centerIn: parent
    }

    Item {
        width: parent.width*0.98
        height: parent.height / 4
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/10
        opacity: 0.5
        visible: busyforums
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "white"
            border.width: parent.width / 50
        }
        Rectangle {
            height: parent.height
            width: totalforums ? parent.width * ((totalforums - busyforums) / totalforums) : 0
            color: "white"
            Behavior on width { SmoothedAnimation { velocity: busyforums ? 30 : -1 } }
        }
        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height / 3
            text: "Updating.."
            color: "white"
            opacity: 0.5
        }
    }
    Text {
        text: "!"
        font.pixelSize: parent.height * 0.8
        anchors.centerIn: parent
        color: "white"
        // visible: messageDialog.topItem || credentialsDialog.topItem
    }
    Timer {
        running: parent.visible
        repeat: true
        triggeredOnStart: true
        interval: busyforums ? 250 : 10000 // Interval could be even longer if there are no busy forums
        onTriggered:  {
            var busycount = 0
            for(var i=0;i<siilihai.forumDatabase.subscriptions.length;i++) {
                if(siilihai.forumDatabase.subscriptions[i].beingUpdated || siilihai.forumDatabase.subscriptions[i].beingSynced || siilihai.forumDatabase.subscriptions[i].scheduledForUpdate) busycount++;
            }
            busyforums = busycount
        }
    }
}

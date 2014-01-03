import QtQuick 2.0

Rectangle {
    property int busyforums: 0
    property int totalforums: subscriptions.length
    visible: !Qt.application.active
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
            Behavior on width { SmoothedAnimation { velocity: 30 } }
        }
        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height / 3
            text: "Updating.."
            color: "white"
            opacity: 0.5
        }
    }

    Timer {
        running: parent.visible
        repeat: true
        triggeredOnStart: true
        interval: busyforums ? 250 : 10000 // Interval could be even longer if there are no busy forums
        onTriggered:  {
            var busycount = 0
            for(var i=0;i<subscriptions.length;i++) {
                if(subscriptions[i].beingUpdated || subscriptions[i].beingSynced || subscriptions[i].scheduledForUpdate) busycount++;
            }
            busyforums = busycount
        }
    }
}

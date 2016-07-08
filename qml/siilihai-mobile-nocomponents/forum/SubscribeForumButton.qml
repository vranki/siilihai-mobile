import QtQuick 2.0
import ".."
import "../widgets"

SimpleButton {
    property bool isSelectedForum: (subscribeForumDialog.subscribeForumId === modelData.id) && !enterUrl
    property bool loadImage: false
    anchors.horizontalCenter: parent.horizontalCenter
    height: filterMatches ? tallButtonHeight + (isSelectedForum ? forumDetails.height + 20 : 0) : 0
    property bool filterMatches: (subscribeList.forumFilterString.length == 0)
                                 || (modelData.alias.toLocaleLowerCase().indexOf(subscribeList.forumFilterString) > -1)
                                 || (String(modelData.forumUrl).toLocaleLowerCase().indexOf(subscribeList.forumFilterString) > -1);

    Behavior on height { SmoothedAnimation { velocity: 800 } }

    onLoadImageChanged: {
        console.log("Loadimage: " + loadImage)
        if(loadImage && favicon.source == "") {
            console.log("Loading image " + modelData.faviconUrl)
            favicon.source = modelData.faviconUrl
        } else if(!loadImage && favicon.status != Image.Ready){
            console.log("Not loading image")
            favicon.source = ""
        }
    }

    Item {
        id: topLine
        width: parent.width
        height: tallButtonHeight
        Text {
            text: modelData.alias
            color: "white"
            anchors.left: favicon.right
            anchors.leftMargin: 5
            font.pixelSize: largePixelSize
            anchors.verticalCenter: parent.verticalCenter
        }
        Image {
            id: favicon
            width: height
            height: tallButtonHeight * 0.8
            source: ""
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.height - height + 1
            visible: filterMatches
        }
    }

    onClicked: {
        if(isSelectedForum) return
        enterUrl = false
        subscribeForumDialog.subscribeForumId = modelData.id
        siilihaimobile.subscriptionManagement.getForum(modelData.id)
    }

    Column {
        id: forumDetails
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        visible: newForum
        anchors.top: topLine.bottom
        anchors.topMargin: 10
        spacing: 10
        property bool newForum: siilihaimobile.subscriptionManagement.newForum
        property bool supportsLogin: newForum ? siilihaimobile.subscriptionManagement.newForum.supportsLogin : false
        Text {
            text: forumDetails.newForum ? siilihaimobile.subscriptionManagement.newForum.forumUrl : ""
            color: color1
            font.pixelSize: smallPixelSize
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally(newForum.forumUrl)
            }
        }
        Text {
            text: forumDetails.supportsLogin ? "" : "Login not supported"
            color: "white"
            font.pixelSize: largePixelSize
            wrapMode: Text.WordWrap
        }
        UserPassForm {
            id: upf
            visible: forumDetails.supportsLogin
            questionText: "Authenticate to forum"
            checked: false
        }
        SimpleButton {
            text: "Subscribe"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                subscribeForumDialog.closeLater()
                siilihaimobile.subscriptionManagement.subscribeThisForum(upf.username, upf.password)
                siilihaimobile.subscriptionManagement.resetNewForum()
                siilihaimobile.subscriptionManagement.resetForumList()
            }
        }
    }
}

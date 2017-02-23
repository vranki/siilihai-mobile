import QtQuick 2.0
import QtQuick.Controls 1.4
import "forum"
import "account"

Item {
    id: mainItem
    property string color1: "#7d7dc0"
    property string color2: "#ffd884"
    property string colorDark: "#003e5e"
    property string colorLessDark: "#407e9e"

    property string color_a_bg: "white"
    property string color_a_text: "black"
    property string color_a_buttons: "#f7f7f7"
    property string color_a_buttons_pressed: "#888888"
    property string color_b_bg: "black"
    property string color_b_text: "white"
    property string color_b_error_bg: "#440000"

    property string color_input: "yellow"

    property int largerDimension: Math.max(width, height)
    property int headerPixelSize: largerDimension / 25
    property int largePixelSize: largerDimension / 50
    property int smallPixelSize: largerDimension / 66

    property int smallButtonHeight: largerDimension / 25
    property int defaultButtonHeight: largerDimension / 16
    property int tallButtonHeight: largerDimension / 13

    property int buttonAnimationDuration: 500

    property bool mainViewVisible: !threadListView.active
                                   && !forumSettingsDialog.active
                                   && !subscribeForumDialog.active
                                   && !settingsLoader.active

    signal backPressed

    Image {
        source: "gfx/backbround-dark.png"
        fillMode: Image.Tile
        width: parent.width
        height: parent.height*2 + forumListView.height
        y: -parent.height - forumListView.contentY
    }
    ForumListView {
        id: forumListView
        // property bool topItem: !threadListView.topItem && !messageListView.topItem
        width: parent.width * 0.98
        height: parent.height// - toolbar.height
        anchors.horizontalCenter: parent.horizontalCenter
        HideEffect {}
    }
    Loader {
        id: threadListView
        property var selectedGroup
        property var model: selectedGroup ? selectedGroup.threads : undefined
        source: "ThreadListView.qml"
        width: parent.width
        height: parent.height
        active: false
    }
    Loader {
        id: messageListView
        property var selectedThread
        property var model: selectedThread ? selectedThread.messages : undefined
        source: "MessageListView.qml"
        width: parent.width
        height: parent.height
        active: false
    }

    Loader {
        id: subscribeForumDialog
        objectName: "subscribeForumDialog"
        source: "forum/SubscribeForumDialog.qml"
        width: parent.width
        height: parent.height
        active: false
        Connections {
            target: subscribeForumDialog.item
            ignoreUnknownSignals: true
            onCloseDialog: subscribeForumDialog.active = false
        }
        Connections {
            target: siilihaimobile
            onShowSubscribeForumDialog: subscribeForumDialog.active = true
        }
    }

    Connections {
        target: siilihaimobile
        onForumSubscribed: {
            returnToTop();
            // Open settings for the forum
            forumListView.selectedForum = sub
            forumSettingsDialog.active = true
        }
    }

    Loader {
        id: forumSettingsDialog
        source: "forum/ForumSettingsDialog.qml"
        width: parent.width
        height: parent.height
        active: false

        Connections {
            target: forumSettingsDialog.item
            ignoreUnknownSignals: true
            onCloseDialog: forumSettingsDialog.active = false
        }
    }

    Loader { // Load on demand
        id: settingsLoader
        source: "SettingsDialog.qml"
        active: false
        width: parent.width
        height: parent.height
        Connections {
            target: settingsLoader.item
            ignoreUnknownSignals: true
            onCloseDialog: settingsLoader.active = false
        }
    }
    /*
    ComposeMessage {
        id: composeMessage
    }

    ForumErrorDialog { id: forumErrorDialog }
    MessageDialog { id: messageDialog }
    */

    Toolbar {
        id: toolbar
        anchors.bottom: parent.bottom
    }

    CredentialsDialog { id: credentialsDialog }

    Loader {
        id: loginWizardLoader
        width: parent.width
        height: parent.height
        source: "account/LoginWizard.qml"
        active: false

        Connections {
            target: siilihaimobile
            onShowLoginWizard: loginWizardLoader.active = true
        }
    }

    InactiveScreen {}

    // Android back button handling
    focus: true // important - otherwise we'll get no key events
/*
    onClosing: {
        if (!loginWizardLoader.active) {
            event.accepted = true
            backPressed()
        }
        close.accepted = false
    }
*/
    Keys.onReleased: {
        // Handle android back button. Quit if in main view, otherwise press back
        if (event.key === Qt.Key_Back && !loginWizardLoader.active && !mainViewVisible) {
            event.accepted = true
            backPressed()
        }
    }
    // Return to top forum list view
    function returnToTop() {
        messageListView.selectedThread = undefined
        messageListView.active = false
        threadListView.selectedGroup = undefined
        threadListView.active = false
        forumListView.selectedForum = undefined
    }
}

import QtQuick 2.0
import "forum"
import "account"

Rectangle {
    property string color1: "#7d7dc0"
    property string color2: "#ffd884"
    property string colorDark: "#003e5e"
    property string colorLessDark: "#407e9e"

    property string color_a_bg: "white"
    property string color_a_text: "black"
    property string color_b_bg: "black"
    property string color_b_text: "white"

    property int headerPointSize: 32
    property int largePointSize: 16

    width: 600
    height: 1024
    color: color_a_bg

    ForumListView {
        id: forumListView
        property bool topItem: !threadListView.topItem && !messageListView.topItem
        width: parent.width * 0.98
        height: parent.height - toolbar.height
        HideEffect {}
    }
    ThreadListView {
        id: threadListView
        property bool topItem: siilihaimobile.selectedGroupId
        width: parent.width
        height: parent.height - toolbar.height
        x: topItem ? 0 : parent.width
        Behavior on x { SmoothedAnimation { velocity: 1500; easing.type: Easing.InOutQuad  } }
        HideEffect {}
    }
    MessageListView {
        id: messageListView
        property bool topItem: siilihaimobile.selectedThreadId
        width: parent.width
        height: parent.height - toolbar.height
        x: topItem ? 0 : parent.width
        Behavior on x { SmoothedAnimation { velocity: 1500; easing.type: Easing.InOutQuad  } }
        HideEffect {}
    }
    SubscribeForumDialog {
        id: subscribeForumDialog
        width: parent.width
        height: parent.height - toolbar.height
    }

    Toolbar {
        id: toolbar
        anchors.bottom: parent.bottom
    }

    LoginWizard {
        width: parent.width
        height: parent.height
    }

    ForumSettingsDialog {
        id: forumSettingsDialog
    }
    SettingsDialog {
        id: settingsDialog
    }
    CredentialsDialog {}
    MessageDialog {}
}

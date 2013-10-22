import QtQuick 2.0

ListView {
    spacing: 10
    snapMode: ListView.SnapToItem
    model: subscriptions
    delegate: ForumButton {}
}

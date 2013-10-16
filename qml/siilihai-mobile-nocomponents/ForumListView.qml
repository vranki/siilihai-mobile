import QtQuick 2.0

ListView {
    spacing: 10
    snapMode: ListView.SnapToItem
    model: ListModel {
        ListElement {
            name: "Foo"
            unreadcount: "43"
        }
        ListElement {
            name: "Bar"
            unreadcount: "32"
        }
        ListElement {
            name: "Baz"
            unreadcount: "21"
        }
    }
    delegate: ForumButton {}
}

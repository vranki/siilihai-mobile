import QtQuick 2.0

ButtonWithUnreadCount {
    text: modelData.displayName
    rightText: modelData.unreadCount
    smallText: modelData.hierarchy
    icon: "gfx/Gnome-folder.svg"
}

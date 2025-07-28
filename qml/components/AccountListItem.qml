import QtQuick 2.2
import Sailfish.Silica 1.0

ListItem {
    id: accountListItem

    contentHeight: accountItem.height + (2 * Theme.paddingSmall)
    contentWidth: parent.width

    Item {
        id: accountItem
        //                        width: parent.width
        height: foodMenuItem.height
        width: parent.width - (2 * Theme.paddingMedium)
        x: Theme.paddingMedium
        y: Theme.paddingSmall

        Row {
            id: foodMenuItem
            width: parent.width

            Column {
                id: colName
                width: parent.width
                height: firstRow.height + secondRow.height

                anchors.verticalCenter: parent.verticalCenter

                Row {
                    id: firstRow
                    width: parent.width
                    height: Theme.fontSizeSmall + Theme.paddingSmall

                    Label {
                        text: model.name
                        width: parent.width / 2
                        height: parent.height
                        truncationMode: TruncationMode.Fade
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                    }

                    Label {
                        text: model.userName
                        width: parent.width / 2
                        height: parent.height
                        truncationMode: TruncationMode.Fade
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        horizontalAlignment: Text.AlignRight
                    }

                }

                Row {
                    id: secondRow
                    width: parent.width
                    height: Theme.fontSizeExtraSmall + Theme.paddingSmall

                    Label {
                        text: model.project
                        width: parent.width / 2
                        height: parent.height
                        truncationMode: TruncationMode.Fade
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignLeft
                    }

                    Label {
                        text: model.hostname
                        width: parent.width / 2
                        height: parent.height
                        truncationMode: TruncationMode.Fade
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignRight
                    }

                }

            }
        }
    }
}

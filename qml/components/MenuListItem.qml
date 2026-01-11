import QtQuick 2.2
import Sailfish.Silica 1.0

ListItem {
    id: menuListItem

    contentHeight: menuItem.height + (2 * Theme.paddingSmall)
    contentWidth: parent.width

    Item {
        id: menuItem
        height: menuItemRow.height + menuItemSeparator.height + 2* Theme.paddingSmall
        width: parent.width - (2 * Theme.paddingMedium)
        x: Theme.paddingMedium
        y: Theme.paddingSmall

        Row {
            id: menuItemRow
            width: parent.width - (2 * Theme.horizontalPageMargin)
            spacing: Theme.paddingMedium
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
 //           y: Theme.paddingSmall

            Column {
                id: menuItemColumn
                width: parent.width
                height: dateRow.height /*+ menuGroupRow.height*/ +  mainCourseNames.height + desertNames.height

                anchors.verticalCenter: parent.verticalCenter

                Row {
                    id: dateRow
                    width: parent.width
                    height: Theme.fontSizeTiny + 1 * Theme.paddingSmall

                    Label {
                        id: dateLabel
                        width: parent.width * 1 / 2
                        height: parent.height
                        text: "" + dateString
                        truncationMode: TruncationMode.Fade
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeTiny
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        // y: Theme.paddingMedium
                    }

                    Label {
                        id: menuGroupLabel
                        width: parent.width * 1 / 2
                        height: parent.height
                        text: menuGroup
                        truncationMode: TruncationMode.Fade
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeTiny
                        font.bold: true
                        horizontalAlignment: Text.AlignRight
                        // y: Theme.paddingMedium
                    }
                }

//                Row {
//                    id: menuGroupRow
//                    width: parent.width
//                    height: Theme.fontSizeTiny + 1 * Theme.paddingSmall

//                    Label {
//                        id: menuGroupLabel
//                        width: parent.width// * 8 / 10
//                        height: parent.height
//                        text: menuGroup
//                        truncationMode: TruncationMode.Fade
//                        color: Theme.primaryColor
//                        font.pixelSize: Theme.fontSizeTiny
//                        font.bold: true
//                        horizontalAlignment: Text.AlignLeft
//                        y: Theme.paddingMedium
//                    }
//                }

                Row {
                    id: mainCourseNamesRow
                    width: parent.width
                    height: Theme.fontSizeMedium + 1 * Theme.paddingSmall

                    Label {
                        id: mainCourseNamesLabel
                        width: parent.width//  * 8 / 10
                        height: parent.height
                        text: mainCourseNames
                        truncationMode: TruncationMode.Fade
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        y: Theme.paddingMedium
                    }
                }

                Row {
                    id: desertNamesRow
                    width: parent.width
                    height: Theme.fontSizeSmall + 2 * Theme.paddingMedium
                    visible: true

                    Label {
                        id: desertNamesLabel
                        width: parent.width//  * 8 / 10
                        height: parent.height
                        text: desertNames
                        truncationMode: TruncationMode.Fade
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        y: Theme.paddingMedium
                    }
                }

            }

        }

        Separator {
            id: menuItemSeparator
            anchors.top: menuItemRow.bottom
            anchors.topMargin: Theme.paddingMedium

            width: parent.width
            color: Theme.primaryColor
            horizontalAlignment: Qt.AlignHCenter
        }

    }

}

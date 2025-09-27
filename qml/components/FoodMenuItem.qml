import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/functions.js" as Functions

Item {
    id: foodMenuItem

    // inspired by https://github.com/Wunderfitz/harbour-fernschreiber/blob/e966eb4abd58e5cb7d2d18b2032130fb18016891/qml/components/MessageListViewItem.qml

    property string starter: ""
    property string mainCourse: ""
    property string desert: ""
    property string selectedIcon: "image://theme/icon-s-accept"

    width: precalculatedValues.textItemWidth
    height: messageBackground.height

    Rectangle {
        id: messageBackground

        height: lunchTextColumn.height
        width: parent.width
        color: Theme.colorScheme === Theme.LightOnDark ? Theme.secondaryHighlightColor : Theme.backgroundGlowColor
        radius: parent.width / 50
        opacity: 0.5
        visible: true
    }

    Column {
        id: lunchTextColumn

        spacing: Theme.paddingSmall

        width: parent.width - (2 * Theme.paddingMedium)
        x: Theme.paddingMedium

        anchors.centerIn: messageBackground

        Row {
            height: 1
            width: parent.width
        }

        Row {
            id: groupLabelRow
            width: parent.width

            Label {
                id: menuGroupLabel
                width: (parent.width - orderedIcon.width) / 2
                text: menuGroup
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignLeft
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                font.bold: false
            }

            Label {
                id: orderedLabel
                rightPadding: Theme.paddingSmall
                width: (parent.width - orderedIcon.width) / 2
                text: ordered ? qsTr("Ordered") : ""
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignRight
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                font.bold: false
            }

            Icon {
                id: orderedIcon
                visible: ordered
                width: ordered ? Theme.iconSizeSmall : 0
                height: orderedIcon.width
                source: ordered ? selectedIcon + "?" + Theme.highlightColor : selectedIcon
                                  + "?" + Theme.primaryColor
            }
        }

        Row {
            id: row2
            width: parent.width

            Column {
                width: parent.width

                Label {
                    width: parent.width
                    text: mainCourse
                    textFormat: Text.StyledText
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignLeft
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                }

                Label {
                    width: parent.width
                    text: Functions.concatStrings(starter, desert, ", ")
                    textFormat: Text.StyledText
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignLeft
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: false
                }
            }
        }

        Row {
            id: priceRow

            width: (parent.width - 2 * Theme.paddingMedium)
            x: Theme.paddingMedium
            height: priceLabel.height

            Label {
                id: priceLabel
                bottomPadding: Theme.paddingSmall
                width: parent.width
                text: qsTr("%1 €").arg(Functions.formatPrice(price))
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignRight
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                font.bold: false
            }
        }
    }
}

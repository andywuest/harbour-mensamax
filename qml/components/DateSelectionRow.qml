import QtQuick 2.2
import Sailfish.Silica 1.0

Row {
    id: dateSelectionRow

    property string dateLabel: ""

    signal previousWeekClicked(int offsetChange)
    signal nextWeekClicked(int offsetChange)

    Column {
        width: parent.width / 3

        Button {
            id: leftButton
            text: "<<"
            preferredWidth: Theme.buttonWidthExtraSmall
            onClicked: previousWeekClicked(-1)
        }
    }

    Column {
        width: parent.width / 3

        Label {
            text: dateLabel
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            height: dateSelectionRow.height
        }
    }

    Column {
        width: parent.width / 3

        Button {
            id: rightButton
            text: ">>"
            preferredWidth: Theme.buttonWidthExtraSmall

            onClicked: nextWeekClicked(+1)

            anchors {
                right: parent.right
                //rightMargin: Theme.horizontalPageMargin
            }
        }
    }
}

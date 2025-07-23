import QtQuick 2.0
import Sailfish.Silica 1.0
Item {

    property string dateLabel: ""

    signal previousWeekClicked(int offsetChange);
    signal nextWeekClicked(int offsetChange);

    Row {
        anchors.fill: parent
        anchors.margins: Theme.paddingLarge
        spacing: Theme.paddingLarge

        Column {
            id: headlineColumn
            width: parent.width
            spacing: Theme.paddingLarge

            // Zeile mit den drei Buttons
            Item {
                width: parent.width
                height: Theme.buttonHeight

                // Linker Button
                Button {
                    id: leftButton
                    text: "<<"
                    width: 100
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    onClicked: previousWeekClicked(-1);
                }

                // Rechter Button
                Button {
                    id: rightButton
                    text: ">>"
                    width: 100
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    onClicked: nextWeekClicked(+1);
                }

                // Mittlerer Button (zentriert)
                Label {
                    id: middleLabel
                    text: dateLabel

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

    }


}

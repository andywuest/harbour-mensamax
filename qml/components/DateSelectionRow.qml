import QtQuick 2.0
import Sailfish.Silica 1.0
Item {

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
                }

                // Rechter Button
                Button {
                    id: rightButton
                    text: ">>"
                    width: 100
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                }

                // Mittlerer Button (zentriert)
                Label {
                    id: middleLabel
                    text: "21.07 - 27.07" // getCurrentWeekRange()

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

    }


}

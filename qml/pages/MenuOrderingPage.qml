import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: twoColumnPage

    SilicaFlickable {
        id: pageFlickable
        width: parent.width
        height: parent.height
        anchors.fill: parent


        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: incidentsHeader
                //: OverviewPage page header
                title: qsTr("Adrian")
                description: "Balance: 233.00 €";
            }

            SilicaListView {
                id: noIncidentsColumn

                height: pageFlickable.height - incidentsHeader.height - Theme.paddingMedium
                                width: parent.width
                                anchors.left: parent.left
                                anchors.right: parent.right
                             clip: true


                Row {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingLarge
                    spacing: Theme.paddingLarge

                    // Left Column: occupies remaining space
                    Column {
                        id: leftColumn
                        width: parent.width - rightColumn.width - Theme.paddingLarge
                        spacing: Theme.paddingMedium

        //                Button {
        //                    text: "Option 1"
        //                    backgroundColor: "gray"
        //                    width: parent.width
        //                    onClicked: console.log("Option 1 clicked")
        //                }

        //                Button {
        //                    text: "Option 2"
        //                    width: parent.width
        //                    onClicked: console.log("Option 2 clicked")
        //                }

        //                Button {
        //                    text: "Option 3"
        //                    width: parent.width
        //                    onClicked: console.log("Option 3 clicked")
        //                }

                        FoodMenuItem {
                            id: lunch1
                            width: parent.width
                            starter: ""
                            mainCourse: "MSC Fischfilet unter der Kruste mit Kräutersauce und Stampfkartoffeln"
                            dessert: "Bio Tagesdessert"
                        }

                        FoodMenuItem {
                            id: lunch2
                            width: parent.width
                            starter: ""
                            mainCourse: "Bio Gemüsefrikadelle mit Bratenso0e, Bluemnkohl und Kartoffelpüree"
                            dessert: "Bio Tagesdessert"
                        }

                    }

                    // Right Column: fixed width
                    Column {
                        id: rightColumn
                        width: 100
                        spacing: Theme.paddingSmall

                        Component.onCompleted: {
                            console.log("selecting first element");
                            listModel.get(0).selected = true;
                        }

                        Repeater {
                            model: ListModel {
                                id: listModel
                                ListElement { name: "Mo"; selected: false }
                                ListElement { name: "Di"; selected: false }
                                ListElement { name: "Mi"; selected: false }
                                ListElement { name: "Do"; selected: false }
                                ListElement { name: "Fr"; selected: false }
                                ListElement { name: "Sa"; selected: false }
                            }

                                // ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

                            delegate: Button {
                                id: delegate
                                text: name
                                width: parent.width
                                backgroundColor: selected ? Theme.highlightBackgroundColor : Theme.backgroundGlowColor
                                onClicked: {
                                    console.log(name + " clicked " + index + " - ")
                                    // delegate.text = delegate.text + "."
                                    //if (modelData)

                                    for (var i = 0; i < listModel.count; i++) {
                                        listModel.get(i).selected = false;
                                    }
                                    listModel.get(index).selected = true;

                                    //selected = !selected
                                    //delegate.backgroundColor = Theme.highlightBackgroundColor
                                    //for (var i = 0; i < )
                                    //
                                }
                            }
                        }



                    }
                }



            }


        }


    }





}

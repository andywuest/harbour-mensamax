import QtQuick 2.2
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
    id: settingsPage

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            console.log("[SettingsPage] store settings!");
            mensamaxSettings.numberOfWeeksToLoad = numberOfWeeksToLoadSlider.value
            mensamaxSettings.sync()
        }
    }

    SilicaFlickable {
        id: settingsFlickable
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: settingsColumn.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: settingsColumn
            width: settingsPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                //: SettingsPage settings title
                title: qsTr("Settings")
            }

            ComboBox {
                id: periodStartComboBox
                //: SettingsPage period start
                label: qsTr("Start load data from")
                currentIndex: mensamaxSettings.periodStart
                //: SettingsPage download strategy explanation
                description: qsTr("Defines the start of the period for which data is loaded")
                menu: ContextMenu {
                    MenuItem {
                        //: SettingsPage current week
                        text: qsTr("Current week")
                    }
                    MenuItem {
                        //: SettingsPage last week
                        text: qsTr("Last week")
                    }
                    MenuItem {
                        //: SettingsPage two weeks ago
                        text: qsTr("Two weeks ago")
                    }
                    onActivated: {
                        mensamaxSettings.periodStart = index
                    }
                }
            }

            Slider {
                id: numberOfWeeksToLoadSlider
                width: parent.width
                minimumValue: 1
                maximumValue: 5
                stepSize: 1
                label: qsTr("Number of weeks to load")
                value: mensamaxSettings.numberOfWeeksToLoad
                valueText: value
            }
        }
    }
}

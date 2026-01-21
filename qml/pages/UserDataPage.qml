import QtQuick 2.2
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: userDataPage
    property var userData

    SilicaFlickable {
        id: userDataFlickable
        anchors.fill: parent

        Column {
            id: userDataColumn

            PageHeader {
                //: UserDataPage title
                title: qsTr("User Data")
            }

            anchors {
                left: parent.left
                right: parent.right
            }

            SectionHeader {
                //: UserDataPage page personal data
                text: qsTr("Personal data")
            }

            LabelValueRow {
                id: firstNameLabelValueRow
                //: UserDataPage first name
                label: qsTr("First name")
                value: ''
            }

            LabelValueRow {
                id: lastNameLabelValueRow
                //: UserDataPage last name
                label: qsTr("Last name")
                value: ''
            }

            LabelValueRow {
                id: loginNameLabelValueRow
                //: UserDataPage login name
                label: qsTr("Login name")
                value: ''
            }

            SectionHeader {
                //: UserDataPage page address data
                text: qsTr("Address")
            }

            LabelValueRow {
                id: streetLabelValueRow
                //: UserDataPage street
                label: qsTr("Street")
                value: ''
            }

            LabelValueRow {
                id: houseNumberCodeLabelValueRow
                //: UserDataPage house number
                label: qsTr("House number")
                value: ''
            }

            LabelValueRow {
                id: zipCodeLabelValueRow
                //: UserDataPage zip code
                label: qsTr("Zip code")
                value: ''
            }

            LabelValueRow {
                id: cityLabelValueRow
                //: UserDataPage city
                label: qsTr("City")
                value: ''
            }
        }
    }

    Component.onCompleted: {
        if (userData) {
            var person = userData.data.meineDaten.angemeldetePerson
            // personal data
            firstNameLabelValueRow.value = person.vorname
            lastNameLabelValueRow.value = person.nachname
            loginNameLabelValueRow.value = person.loginName
            // address
            streetLabelValueRow.value = person.strasse
            zipCodeLabelValueRow.value = person.plz
            houseNumberCodeLabelValueRow.value = person.hausNr
            cityLabelValueRow.value = person.ort
        }
    }
}

import QtQuick 2.2
import Sailfish.Silica 1.0

import "../components"
import "../components/thirdparty"

Page {
    id: accountsPage

    property bool showLoadingIndicator
    property var token
    property var balanceData
    property var userData
    property var currentWeekMenu
    property string currentDateLabel

    allowedOrientations: Orientation.All

    function removeAccountAtIndex(index) {
        console.log("[AccountsOverview] - remove account requested at index " + index)
        var accounts = JSON.parse(mensamaxSettings.accountsString)
        if (index <= accounts.length) {
            accounts.splice(index, 1)
            mensamaxSettings.accountsString = JSON.stringify(accounts)
            mensamaxSettings.sync()
            repopulateModel()
            console.log("[AccountsOverview] - removed account at index " + index)
        } else {
            console.log("[AccountsOverview] - cannot remove index " + index
                        + " because we only have " + accounts.length + " accounts.")
        }
    }

    function repopulateModel() {
        accountModel.clear()
        console.log("[AccountsOverview] - repopulateModel - loading accounts")
        console.log("[AccountsOverview] - " + mensamaxSettings.accountsString)
        var accounts = JSON.parse(mensamaxSettings.accountsString)
        for (var i = 0; i < accounts.length; i++) {
            accountModel.append(accounts[i])
        }
    }

    AppNotification {
        id: accountProblemNotification
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                //: AccountsOverviewPage about menu item
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Create account")
                onClicked: pageStack.animatorPush(
                               Qt.resolvedUrl("AccountCreationDialog.qml"), {
                                                  selectedIndex: -1
                                              })
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: accountsPage.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Accounts")
            }

            ViewPlaceholder {
                enabled: accountModel.count == 0
                text: qsTr("No accounts yet")
                hintText: qsTr("Pull down to add accounts")
            }

            SilicaListView {
                id: noIncidentsColumn
                visible: accountModel.count > 0

                anchors.left: parent.left
                anchors.right: parent.right

                height: accountsPage.height
                clip: true

                model: ListModel {
                    id: accountModel
                }

                delegate: AccountListItem {
                    id: accountListItem

                    menu: Component {
                        ContextMenu {
                            MenuItem {
                                text: qsTr("Edit Account")
                                onClicked: {
                                    var selectedIndex = index
                                    pageStack.push(
                                                Qt.resolvedUrl(
                                                    "AccountCreationDialog.qml"),
                                                    {
                                                        selectedIndex: selectedIndex
                                                    })
                                }
                            }

                            MenuItem {
                                text: qsTr("Delete Account")
                                onClicked: {
                                    var selectedIndex = index
                                    var removeAccountFunction = accountsPage.removeAccountAtIndex
                                    Remorse.itemAction(accountListItem, qsTr(
                                                           "Deleting account"),
                                                       function () {
                                                           removeAccountFunction(selectedIndex)
                                                       })
                                }
                            }
                        }
                    }

                    onClicked: {
                        console.log("[AccountsOverview] " + index + ", " + model.userName)
                        showLoadingIndicator = true
                        mensaMax.executeLogin(model.project,
                                              model.installation,
                                              model.userName, model.password,
                                              model.hostname)
                    }
                }
            }
        }
    }

    LoadingIndicator {
        visible: showLoadingIndicator
        Behavior on opacity {
            NumberAnimation {}
        }
        opacity: showLoadingIndicator ? 1 : 0
        height: parent.height
        width: parent.width
    }

    Connections {
        target: mensaMax

        // TODO document: name des parameters wird im signal definiert
        onLoginAvailable: {
            if (accountsPage.status !== PageStatus.Active) {
                return
            }
            console.log("[AccountsOverview] - loginAvailable " + reply)
            var parsedResult = JSON.parse(reply)
            token = parsedResult.text
            // get the balance data
            mensaMax.executeGetBalance(token)
        }

        onGetBalanceAvailable: {
            console.log("[AccountsOverview] - getBalanceAvailable " + reply)
            balanceData = JSON.parse(reply)
            // get the user data
            mensaMax.executeGetUserData(token)
        }

        onGetUserDataAvailable: {
            console.log("[AccountsOverview] - getUserDataAvailable " + reply)
            userData = JSON.parse(reply)
            // get menu for current week
            mensaMax.executeGetMenus(token, 0)
        }

        onGetMenusAvailable: {
            if (accountsPage.status !== PageStatus.Active) {
                return
            }
            console.log("[AccountsOverview] - getMenusAvailable " + reply)
            currentWeekMenu = JSON.parse(reply)
            currentDateLabel = dateLabel
            showLoadingIndicator = false
            pageStack.animatorPush(Qt.resolvedUrl("MenuOrderingPage.qml"), {
                                       "token": token,
                                       "menues": currentWeekMenu,
                                       "dateLabel": currentDateLabel,
                                       "balanceData": balanceData,
                                       "userData": userData
                                   })
        }

        onRequestError: {
            console.log("[AccountsOverview] - requestError " + errorMessage)
            showLoadingIndicator = false
            accountProblemNotification.show(errorMessage)
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            repopulateModel()
        }
    }
}

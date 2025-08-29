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

    AppNotification {
        id: accountProblemNotification
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Create account")
                onClicked: pageStack.animatorPush(
                               Qt.resolvedUrl("AccountCreationDialog.qml"))
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
        id: pollenLoadingIndicator
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
                                       "dateLabel": currentDateLabel
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
            accountModel.clear();
            console.log("[AccountsOverview] - loading accounts");
            console.log("[AccountsOverview] - " + mensamaxSettings.accountsString);
            var accounts = JSON.parse(mensamaxSettings.accountsString);
            for (var i = 0; i < accounts.length; i++) {
                accountModel.append(accounts[i]);
            }
        }
    }

}

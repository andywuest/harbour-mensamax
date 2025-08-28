import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/thirdparty"

Dialog {
    id: accountCreationDialog

    property bool showLoadingIndicator: false
    property bool loginVerified: false

    canAccept: loginVerified

    AppNotification {
        id: accountProblemNotification
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: credentialsColumn.height

        Column {
            id: credentialsColumn
            width: parent.width
            spacing: Theme.paddingMedium

            DialogHeader {
                title: qsTr("Create Account")
            }

            SectionHeader {
                text: qsTr("Your Credentials")
            }

            TextField {
                id: nameTextField
                width: parent.width
                label: qsTr("Name (of your child, free text)")
                labelVisible: true
            }

            TextField {
                id: projectTextField
                width: parent.width
                label: qsTr("Project")
                labelVisible: true
                onTextChanged: {
                    loginVerified = false
                }
            }

            TextField {
                id: installationTextField
                width: parent.width
                label: qsTr("Installation")
                labelVisible: true
                onTextChanged: {
                    loginVerified = false
                }
            }

            TextField {
                id: userNameTextField
                width: parent.width
                label: qsTr("User name")
                labelVisible: true
                onTextChanged: {
                    loginVerified = false
                }
            }

            TextField {
                id: passwordTextField
                width: parent.width
                label: qsTr("Client Secret")
                labelVisible: true
                onTextChanged: {
                    loginVerified = false
                }
            }

            TextField {
                id: hostnameTextField
                width: parent.width
                label: qsTr("Server")
                placeholderText: qsTr("e.g. mensahaus.de")
                labelVisible: true
                onTextChanged: {
                    loginVerified = false
                }
            }

            Button {
                //width: parent.width - (6 * Theme.paddingLarge)
                //x: 3 * Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter

                //: AccountCreationDialog test login button
                text: qsTr("Test Login")
                onClicked: {
                    showLoadingIndicator = true
                    mensaMax.executeLogin(projectTextField.text,
                                          installationTextField.text,
                                          userNameTextField.text,
                                          passwordTextField.text,
                                          hostnameTextField.text)
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

        onLoginAvailable: {
            if (accountCreationDialog.status !== PageStatus.Active) {
                return
            }
            console.log("[AccountCreationDialog] - loginAvailable " + reply)
            var parsedResult = JSON.parse(reply)
            var token = parsedResult.text
            if (token && token.length > 0) {
                loginVerified = true
            }
            showLoadingIndicator = false
        }

        onRequestError: {
            console.log("[AccountCreationDialog] - requestError " + errorMessage)
            showLoadingIndicator = false
            accountProblemNotification.show(errorMessage)
        }
    }

    onAccepted: {
        console.log("[AccountCreationDialog] accepted")
        var data = {}
        data.project = projectTextField.text
        data.installation = installationTextField.text
        data.userName = userNameTextField.text
        data.password = passwordTextField.text
        data.hostname = hostnameTextField.text
        data.name = nameTextField.text
        // store in configuration
        mensamaxSettings.accounts.push(JSON.stringify(data))
        mensamaxSettings.sync()
        console.log("[AccountCreationDialog] number accounts : " + mensamaxSettings.accounts.length)
    }
}

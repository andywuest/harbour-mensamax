import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: accountCreationDialog

    property bool loginVerified: false

    canAccept: loginVerified

    function connectSlots() {
        console.log("connect - slots")
        mensaMax.loginAvailable.connect(loginResultHandler)
        mensaMax.requestError.connect(errorResultHandler)
    }

    function disconnectSlots() {
        console.log("disconnect - slots")
        mensaMax.loginAvailable.disconnect(loginResultHandler)
        mensaMax.requestError.disconnect(errorResultHandler)
    }

    function loginResultHandler(result) {
        console.log("[AccountCreationDialog] login result handler : " + result)
        var parsedResult = JSON.parse(result)
        var token = parsedResult.text
        if (token && token.length > 0) {
            loginVerified = true
        }
    }

    function errorResultHandler(result) {
        console.log("[AccountCreationDialog] error result handler -> " + result)
        loginVerified = false
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
                text: qsTr("Validation Result")
            }

            Label {
                width: parent.width
                text: qsTr("Login: ") + " " + (loginVerified ? qsTr("success") : qsTr("-"))
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
                    mensaMax.executeLogin(projectTextField.text,
                                          installationTextField.text,
                                          userNameTextField.text,
                                          passwordTextField.text,
                                          hostnameTextField.text)
                }
            }
        }
    }

    Component.onCompleted: {
        connectSlots()
    }

    onAccepted: {
        console.log("[AccountCreationDialog] accepted")
        var data = {};
        data.project = projectTextField.text;
        data.installation = installationTextField.text;
        data.userName = userNameTextField.text;
        data.password = passwordTextField.text;
        data.hostname = hostnameTextField.text;
        data.name = nameTextField.text;
        // store in configuration
        mensamaxSettings.accounts.push(JSON.stringify(data));
        mensamaxSettings.sync();
        console.log("[AccountCreationDialog] accounts : " + mensamaxSettings.accounts.length)
    }

}

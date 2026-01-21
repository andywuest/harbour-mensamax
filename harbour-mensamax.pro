# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-mensamax

CONFIG += sailfishapp

DEFINES += VERSION_NUMBER=\\\"$$(VERSION_NUMBER)\\\"

SOURCES += src/harbour-mensamax.cpp

DISTFILES += qml/harbour-mensamax.qml \
    qml/components/AboutDescription.qml \
    qml/components/AboutIconLabel.qml \
    qml/components/AccountListItem.qml \
    qml/components/DateSelectionRow.qml \
    qml/components/FoodMenuItem.qml \
    qml/components/LabelValueRow.qml \
    qml/components/MenuListItem.qml \
    qml/components/thirdparty/AppNotification.qml \
    qml/components/thirdparty/AppNotificationItem.qml \
    qml/components/thirdparty/LoadingIndicator.qml \
    qml/cover/CoverPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/AccountCreationDialog.qml \
    qml/pages/AccountsOverviewPage.qml \
    qml/pages/MenuListPage.qml \
    qml/pages/MenuSelectionPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/UserDataPage.qml \
    qml/pages/icons/github.svg \
    qml/pages/icons/paypal.svg \
    qml/js/constants.js \
    qml/js/functions.js \
    rpm/harbour-mensamax.changes.in \
    rpm/harbour-mensamax.changes.run.in \
    rpm/harbour-mensamax.spec \
    translations/*.ts \
    harbour-mensamax.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-mensamax-de.ts

include(harbour-mensamax.pri)


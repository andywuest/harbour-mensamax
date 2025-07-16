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

SOURCES += src/harbour-mensamax.cpp

DISTFILES += qml/harbour-mensamax.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
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

# HEADERS += \
#    src/constants.h \
#    src/mensamax.h

include(harbour-mensamax.pri)


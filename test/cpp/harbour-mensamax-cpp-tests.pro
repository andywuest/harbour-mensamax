QT += qml testlib network sql
QT -= gui

CONFIG += c++11 qt

SOURCES += testmain.cpp \
    mensamaxtests.cpp

HEADERS += \
    mensamaxtests.h

INCLUDEPATH += ../../
include(../../harbour-mensamax.pri)

TARGET = MensaMaxTests

# DISTFILES +=

DEFINES += UNIT_TEST


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

DISTFILES += \
    testdata/ie00b57x3v84.json \
    testdata/ing_news.json \
    testdata/divvydiary.json

DEFINES += UNIT_TEST


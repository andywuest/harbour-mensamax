#/bin/bash

set -x

export QT_SELECT=qt5
rm -rf *.xml


env LC_ALL=de_DE.UTF-8 LC_NUMERIC=de_DE.utf8 QML_XHR_ALLOW_FILE_READ=1 qmltestrunner -platform offscreen -junitxml -o junit.xml


#include "mensamaxtests.h"
#include <QtTest/QtTest>

void MensaMaxTests::init() { mensaMax = new MensaMax(nullptr); }

void MensaMaxTests::testExecuteLoginData() {

  mensaMax->executeLoginData("mullvie");
}

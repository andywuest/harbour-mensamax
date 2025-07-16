#ifndef MENSAMAX_TESTS_H
#define MENSAMAX_TESTS_H

#include <QObject>

//#include "src/dividenddata/dividenddataupdateworker.h"
//#include "src/ingdibautils.h"
//#include "src/newsdata/ingdibanews.h"
#include "src/mensamax.h"

class MensaMaxTests : public QObject {
  Q_OBJECT

private:
  MensaMax *mensaMax;

protected:
  //    QByteArray readFileData(const QString &fileName);

private slots:
  void init();

  void testExecuteLoginData();
  /*
      // ING-DIBA Security Backend
      void testIngDibaUtilsConvertTimestampToLocalTimestamp();
      void testIngDibaBackendIsValidSecurityCategory();
      void testIngDibaBackendProcessSearchResult();

      // ING-DIBA News Backend
      void testIngDibaNewsProcessSearchResult();
      void testIngDibaNewsFilterContent();

      // DividendDataUpdate Worker
      void testDividendDataUpdateWorkerCalculateConvertedAmount();
      */
};

#endif // MENSAMAX_TESTS_H

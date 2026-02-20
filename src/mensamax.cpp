#include "mensamax.h"
#include "constants.h"
#include "httpresponse.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QThread>
#include <QUrl>

MensaMax::MensaMax(QObject *parent)
    : QObject(parent), networkAccessManager(new QNetworkAccessManager(this)),
      networkConfigurationManager(new QNetworkConfigurationManager(this)),
      settings("harbour-mensamax", "settings") {}

QNetworkRequest MensaMax::prepareRequest(const QString &endpoint,
                                         const QString &token) {
  qDebug() << "MensaMax::prepareRequest " << endpoint;

  QString requestUrl = QString(BASE_URL).arg(this->hostname) + endpoint;
  QString cookieValue = QString(COOKIE_VALUE).arg(this->hostname);
  QUrl url = QUrl(requestUrl);
  QNetworkRequest request(url);

  qDebug() << "token: " << token;
  qDebug() << "url: " << requestUrl;
  qDebug() << "cookie value: " << cookieValue;

  request.setHeader(QNetworkRequest::ContentTypeHeader, MIME_TYPE_JSON);
  request.setHeader(QNetworkRequest::UserAgentHeader, USER_AGENT);
  request.setRawHeader("Accept", MIME_TYPE_JSON);
  request.setRawHeader("Cookie", cookieValue.toUtf8());

  if (!token.isEmpty()) {
    request.setRawHeader("Authorization",
                         QString("Bearer ").append(token).toUtf8());
  }

  return request;
}

void MensaMax::executeLogin(const QString &project, const QString &location,
                            const QString &userName, const QString &password,
                            const QString &hostname) {
  qDebug() << "MensaMax::executeLogin " << userName;
  qDebug() << "MensaMax::executeLogin " << hostname;

  this->hostname = hostname;

  QNetworkRequest request = prepareRequest(QString(ENDPOINT_LOGIN), QString());

  const QString postData =
      QString(POST_BODY_LOGIN).arg(project, userName, password, location);

  qDebug() << "postData: " << postData;

  QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());

  connect(reply, &QNetworkReply::finished, this,
          [this, reply]() { onExecuteLogin(reply); });
}

void MensaMax::executeLogout(const QString &token) {
  qDebug() << "MensaMax::executeLogout ";

  QNetworkRequest request = prepareRequest(QString(ENDPOINT_LOGOUT), token);

  const QString postData = QString();

  QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());

  connect(reply, &QNetworkReply::finished, this, [reply]() {
    reply->deleteLater();
    qDebug() << "return code : "
             << reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute)
                    .toString();
  });
}

void MensaMax::onExecuteLogin(QNetworkReply *reply) {
  qDebug() << "MensaMax::onExecuteLogin ";
  reply->deleteLater();

  auto response = HttpResponse(reply);

  if (response.hasNetworkError()) {
    return emit requestError("Return code: " + response.errorString());
  }

  int code = response.statusCode();
  if (code != HTTP_STATUS_CODE_OK) {
    return emit requestError("Return code: " + response.errorString());
  }

  qDebug() << "login result : " << QString(response.content());

  emit loginAvailable(QString(response.content()));
}

void MensaMax::executeGetBalance(const QString &token) {
  qDebug() << "MensaMax::executeGetBalance " << token;

  QNetworkRequest request = prepareRequest(QString(), token);

  const QString postData = QString(POST_GET_BALANCE);

  qDebug() << "postData: " << postData;

  QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());

  connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this,
          SLOT(handleRequestError(QNetworkReply::NetworkError)));
  connect(reply, &QNetworkReply::finished, this, [this, reply]() {
    reply->deleteLater();

    auto response = HttpResponse(reply);

    if (response.hasNetworkError()) {
      return emit requestError("Return code: " + response.errorString());
    }

    if (response.hasGraphQLError()) {
      emit getBalanceAvailable("{}");
      return emit requestError("Return code: graphQL Error ");
    }

    QString responseData = QString(response.content());
    qDebug() << "return code : "
             << reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute)
                    .toString();
    qDebug() << "response : " << responseData;
    emit getBalanceAvailable(responseData);
  });
}

void MensaMax::executeGetUserData(const QString &token) {
  qDebug() << "MensaMax::executeGetUserData " << token;

  QNetworkRequest request = prepareRequest(QString(), token);

  const QString postData = QString(POST_GET_USER_DATA);

  qDebug() << "postData: " << postData;

  QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());

  connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this,
          SLOT(handleRequestError(QNetworkReply::NetworkError)));
  connect(reply, &QNetworkReply::finished, this, [this, reply]() {
    reply->deleteLater();
    QString response = QString(reply->readAll());
    qDebug() << "return code : "
             << reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute)
                    .toString();
    qDebug() << "response : " << response;
    emit getUserDataAvailable(response);
  });
}

void MensaMax::executeUnsubscribeMeal(const QString &token,
                                      const long lunchId) {
  qDebug() << "MensaMax::executeUnsubscribeMeal " << token;

  QNetworkRequest request = prepareRequest(QString(), token);

  const QString postData = QString(POST_UNSUBSCRIBE_MEAL).arg(lunchId);

  qDebug() << "postData: " << postData;

  QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());
  connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this,
          SLOT(handleRequestError(QNetworkReply::NetworkError)));
  connect(reply, &QNetworkReply::finished, this, [this, reply, lunchId]() {
    emit unsubscribeMealAvailable(
        createSubscriptionResponse(reply, false, lunchId));
  });
}

QString MensaMax::createIdempotencyToken() {
  // UT version in JS: Date.now().toString() + Math.random().toString()
  qint64 nowMs = QDateTime::currentMSecsSinceEpoch();
  return QString::number(nowMs) + "." + QString::number(qrand());
}

void MensaMax::executeSubscribeMeal(const QString &token, const long lunchId) {
  qDebug() << "MensaMax::executesubscribeMeal " << token;

  QNetworkRequest request = prepareRequest(QString(), token);

  const QString idempotencyToken = createIdempotencyToken();
  const QString postData =
      QString(POST_SUBSCRIBE_MEAL).arg(lunchId).arg(idempotencyToken);

  qDebug() << "postData: " << postData;

  QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());
  connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this,
          SLOT(handleRequestError(QNetworkReply::NetworkError)));
  connect(reply, &QNetworkReply::finished, this, [this, reply, lunchId]() {
    emit subscribeMealAvailable(
        createSubscriptionResponse(reply, true, lunchId));
  });
}

QString MensaMax::createSubscriptionResponse(QNetworkReply *reply,
                                             const bool subscription,
                                             const long lunchId) {
  qDebug() << "MensaMax::createSubscriptionResponse";
  reply->deleteLater();
  const QString response = QString(reply->readAll());
  qDebug() << "return code : "
           << reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute)
                  .toString();
  qDebug() << "response : " << response;

  QString orderNodeName =
      (subscription ? "meinEssenBestellen" : "meinEssenAbbestellen");

  bool success = true;
  QString message = QString("");
  const QJsonDocument responseDoc = QJsonDocument::fromJson(response.toUtf8());
  if (responseDoc.isObject()) {
    QJsonObject root = responseDoc.object();
    QJsonObject dataNode = root.value("data").toObject();
    if (!dataNode.isEmpty()) {
      QJsonObject orderNode = dataNode.value(orderNodeName).toObject();
      if (!orderNode.isEmpty()) {
        success = !orderNode.value("error").toBool(false);
        message = orderNode.value("message").toString();
      }
    }
  }

  QJsonObject root;
  root["success"] = success;
  root["lunchId"] = QJsonValue((qint64)lunchId);
  root["message"] = message;
  QJsonDocument doc(root);
  return QString::fromUtf8(doc.toJson());
}

void MensaMax::executeGetMenus(const QString &token, const int weekOffset) {
  qDebug() << "MensaMax::executeGetMenus token: " << token
           << ", weekOffset : " << weekOffset;

  int dayOfWeek = QDate::currentDate().dayOfWeek();
  qDebug() << "dayOfWeek :" << dayOfWeek;

  int dayOffset = 7;
  if (dayOfWeek >= 1) {
    dayOffset = -dayOfWeek + 1;
  }

  qDebug() << "dayOffset :" << dayOffset;

  startDate = QDate::currentDate().addDays(weekOffset * 7).addDays(dayOffset);
  endDate = startDate.addDays(6);

  QNetworkRequest request = prepareRequest(QString(), token);

  const QString postData = QString(POST_GET_MENUS_DATA)
                               .arg(startDate.toString(GRAPHQL_DATE_FORMAT),
                                    endDate.toString(GRAPHQL_DATE_FORMAT));

  qDebug() << "postData: " << postData;

  QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());

  connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this,
          SLOT(handleRequestError(QNetworkReply::NetworkError)));
  connect(reply, &QNetworkReply::finished, this, [this, reply]() {
    reply->deleteLater();
    QString response = QString(reply->readAll());
    qDebug() << "return code : "
             << reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute)
                    .toString();
    qDebug() << "response : " << response;
    emit getMenusAvailable(response, startDate.toString("dd.MM") + " - " +
                                         endDate.toString("dd.MM"));
  });
}

void MensaMax::handleRequestError(QNetworkReply::NetworkError error) {
  QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
  qWarning() << "MensaMax::handleRequestError:" << static_cast<int>(error)
             << reply->errorString() << reply->readAll();

  qDebug() << "failed";

  emit requestError("Return code: " + QString::number(static_cast<int>(error)) +
                    " - " + reply->errorString());
}

void MensaMax::handleExecuteLoginFinished() {
  qDebug() << "MensaMax::handleLookupMarketDataFinished";
  QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
  reply->deleteLater();
  if (reply->error() != QNetworkReply::NoError) {
    return;
  }

  qDebug() << "finsihed";
}

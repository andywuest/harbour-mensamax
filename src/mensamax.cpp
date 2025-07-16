#include "mensamax.h"
#include "constants.h"

#include <QThread>
#include <QUrl>

MensaMax::MensaMax(QObject *parent) : QObject(parent), networkAccessManager(new QNetworkAccessManager(this))
  , networkConfigurationManager(new QNetworkConfigurationManager(this))
  , settings("harbour-mensamax", "settings") {

}

void MensaMax::executeLogin(const QString &project, const QString &location, const QString &userName, const QString &password) {
    qDebug() << "MensaMax::executeLogin " << userName;
    QString requestUrl = QString(BASE_URL) + QString(ENDPOINT_LOGIN);
    QUrl url = QUrl(requestUrl);
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, MIME_TYPE_JSON);
    request.setHeader(QNetworkRequest::UserAgentHeader, USER_AGENT);
    request.setRawHeader("Accept", MIME_TYPE_JSON);
    request.setRawHeader("Cookie", "mensamax_superglue=https://mensahaus.de;");

    const QString postData = QString(POST_BODY_LOGIN).arg(project, userName, password, location);

    qDebug() << "url: " << requestUrl;
    qDebug() << "postData: " << postData;

    QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());

    connect(reply,
            SIGNAL(error(QNetworkReply::NetworkError)),
            this,
            SLOT(handleRequestError(QNetworkReply::NetworkError)));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        QString response = QString(reply->readAll());
        qDebug() << "return code : " << reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
        qDebug() << "response : " << response;
        emit loginAvailable(response);
    });
}

void MensaMax::executeGetBalance(const QString &token) {
    qDebug() << "MensaMax::executeGetBalance " << token;

    QString requestUrl = QString(BASE_URL);
    QUrl url = QUrl(requestUrl);
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, MIME_TYPE_JSON);
    request.setHeader(QNetworkRequest::UserAgentHeader, USER_AGENT);
    request.setRawHeader("Accept", MIME_TYPE_JSON);
    request.setRawHeader("Authorization", QString("Bearer ").append(token).toUtf8());
    request.setRawHeader("Cookie", "mensamax_superglue=https://mensahaus.de;");

    const QString postData = QString(POST_GET_BALANCE);

    qDebug() << "url: " << requestUrl;
    qDebug() << "postData: " << postData;
    qDebug() << "token: " << token;

    QNetworkReply *reply = networkAccessManager->post(request, postData.toUtf8());

    connect(reply,
            SIGNAL(error(QNetworkReply::NetworkError)),
            this,
            SLOT(handleRequestError(QNetworkReply::NetworkError)));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        QString response = QString(reply->readAll());
        qDebug() << "return code : " << reply->attribute(QNetworkRequest::HttpReasonPhraseAttribute).toString();
        qDebug() << "response : " << response;
        emit getBalanceAvailable(response);
    });


}

void MensaMax::handleRequestError(QNetworkReply::NetworkError error) {
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    qWarning() << "MensaMax::handleRequestError:" << static_cast<int>(error)
               << reply->errorString() << reply->readAll();

    qDebug() << "failed";

    emit requestError("Return code: " + QString::number(static_cast<int>(error)) + " - " + reply->errorString());
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

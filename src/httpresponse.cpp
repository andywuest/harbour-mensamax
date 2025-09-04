#include "httpresponse.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

int HttpResponse::statusCode() const {
    return m_inner->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
}

bool HttpResponse::hasNetworkError() const {
    int error = m_inner->error();
    return error > 0 && error <= QNetworkReply::UnknownNetworkError;
}

bool HttpResponse::hasGraphQLError() {
    QJsonDocument jsonDocument = QJsonDocument::fromJson(content());
    if (jsonDocument.isObject()) {
        QJsonObject rootObject = jsonDocument.object();
        QJsonArray errors = rootObject.value("errors").toArray();
        if (errors.size() > 0) {
            qDebug() << "graphQL error : " << errors.at(0).toObject().value("message");
            return true;
        }
    }
    return false;
}

QByteArray HttpResponse::content() {
    if (m_content.isNull()) {
        readContent();
    }
    return m_content;
}

void HttpResponse::readContent() {
    Q_ASSERT(m_content.isNull());
    m_content = m_inner->readAll();
}

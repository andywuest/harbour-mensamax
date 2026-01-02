#ifndef HTTPRESPONSE_H
#define HTTPRESPONSE_H

#include <QNetworkReply>

// original source
// https://github.com/R1tschY/harbour-datameter/blob/master/src/networkresponse.h

class HttpResponse {

public:
  HttpResponse(QNetworkReply *reply) : m_inner(reply) {}

  int statusCode() const;

  bool hasNetworkError() const;
  bool hasGraphQLError();
  QString errorString() const { return m_inner->errorString(); }

  QString header(const QByteArray &name) const;

  QByteArray content();

private:
  QNetworkReply *m_inner;
  QByteArray m_content;

  void readContent();
};

inline QString HttpResponse::header(const QByteArray &name) const {
  return m_inner->rawHeader(name);
}

#endif // HTTPRESPONSE_H

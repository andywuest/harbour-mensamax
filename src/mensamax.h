#ifndef MENSAMAX_H
#define MENSAMAX_H

#include <QNetworkAccessManager>
#include <QNetworkConfigurationManager>
#include <QNetworkReply>
#include <QObject>
#include <QSettings>

class MensaMax : public QObject
{
    Q_OBJECT
public:
    explicit MensaMax(QObject *parent = nullptr);
    ~MensaMax() = default;

    Q_INVOKABLE void executeLogin(const QString &project, const QString &location, const QString &userName, const QString &password);
    Q_INVOKABLE void executeGetBalance(const QString &token);
    Q_INVOKABLE void executeGetUserData(const QString &token);

signals:
    // signals for the qml part
    Q_SIGNAL void loginAvailable(const QString &reply);
    Q_SIGNAL void getBalanceAvailable(const QString &reply);
    Q_SIGNAL void getUserDataAvailable(const QString &reply);
    Q_SIGNAL void requestError(const QString &errorMessage);

private:
    QNetworkAccessManager *const networkAccessManager;
    QNetworkConfigurationManager *const networkConfigurationManager;

    QSettings settings;

protected slots:

    // TODO also in the euroinvestor backend hierarchy - needs to be consolidated
    void handleRequestError(QNetworkReply::NetworkError error);

#ifdef UNIT_TEST
    friend class MensaMaxTests;
#endif

private slots:
    void handleExecuteLoginFinished();

};

#endif // MENSAMAX_H

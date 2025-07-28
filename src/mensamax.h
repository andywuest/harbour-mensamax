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

    Q_INVOKABLE void executeLogin(const QString &project, const QString &location, const QString &userName, const QString &password, const QString &hostname);
    Q_INVOKABLE void executeGetBalance(const QString &token);
    Q_INVOKABLE void executeGetUserData(const QString &token);
    Q_INVOKABLE void executeGetMenus(const QString &token, const int weekOffset); // TODO dates

signals:
    // signals for the qml part
    Q_SIGNAL void loginAvailable(const QString &reply);
    Q_SIGNAL void getBalanceAvailable(const QString &reply);
    Q_SIGNAL void getUserDataAvailable(const QString &reply);
    Q_SIGNAL void getMenusAvailable(const QString &reply, const QString dateLabel);
    Q_SIGNAL void requestError(const QString &errorMessage);

private:
    QNetworkAccessManager *const networkAccessManager;
    QNetworkConfigurationManager *const networkConfigurationManager;

    void onExecuteLogin(QNetworkReply *reply);

    QSettings settings;
    QString hostname;
    QDate startDate;
    QDate endDate;

protected:

    QNetworkRequest  prepareRequest(const QString &endpoint, const QString &token);

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

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include "constants.h"
#include "mensamax.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    app->setOrganizationDomain(ORGANISATION);
    app->setOrganizationName(ORGANISATION); // needed for Sailjail
    app->setApplicationName(APP_NAME);

    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QQmlContext *context = view.data()->rootContext();
    MensaMax mensaMax;
    context->setContextProperty("mensaMax", &mensaMax);

    view->setSource(SailfishApp::pathTo("qml/harbour-mensamax.qml"));
    view->show();
    return app->exec();
}

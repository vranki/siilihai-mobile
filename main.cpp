#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlComponent>
#include "qtquick2applicationviewer.h"
#include "siilihaimobile.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QtQuick2ApplicationViewer viewer;
#ifdef use_components
    viewer.setMainQmlFile(QStringLiteral("qrc:/qml/siilihai-mobile/main.qml"));
#else
    viewer.setMainQmlFile("../siilihai-mobile/qml/siilihai-mobile-nocomponents/main.qml");
    // viewer.setSource(QUrl("qrc:/qml/siilihai-mobile-nocomponents/main.qml"));
#endif
    // viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.showExpanded();

//    SiilihaiMobile shm(0, viewer.engine()->rootContext(), viewer.rootObject());
//    shm.launchSiilihai();
    int ret = app.exec();

    /*
    // Ugly hack to make sure Siilihai quits graceously after swipe close
    qDebug() << Q_FUNC_INFO << "exec() exited";
    if(!shm.isHaltRequested()) {
        qDebug() << Q_FUNC_INFO << "halt NOT requested yet - forcing halt";
        shm.haltSiilihai();
        app.exec(); // Re-start Qt main loop
        // Crashes here
    } else {
        qDebug() << Q_FUNC_INFO << "halt ok";
    }
    */
    return ret;
}

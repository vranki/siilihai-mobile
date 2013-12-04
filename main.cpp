#include <QGuiApplication>

#include <QQmlComponent>
#include <QDebug>
#include "qtquick2applicationviewer.h"
#include "siilihaimobile.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("Siilihai");
    QCoreApplication::setOrganizationDomain("siilihai.com");
    QCoreApplication::setApplicationName("Siilihai-mobile");
    QtQuick2ApplicationViewer viewer;
    SiilihaiMobile shm(0, &viewer);
    app.installEventFilter(&shm);
#ifdef use_components
    viewer.setMainQmlFile(QStringLiteral("qrc:/qml/siilihai-mobile/main.qml"));
#else
    // Find the main.qml to use..
    QFile mainQml("../siilihai-mobile/qml/siilihai-mobile-nocomponents/main.qml");
    if(mainQml.exists()) {
        viewer.setMainQmlFile(mainQml.fileName());
    } else {
        mainQml.setFileName("/usr/share/siilihai-mobile/qml/siilihai-mobile-nocomponents/main.qml");
        if(mainQml.exists()) {
            viewer.setMainQmlFile(mainQml.fileName());
        } else {
            qDebug() << Q_FUNC_INFO << "Cannot open main.qml!";
            return -1;
        }
    }
#endif
    // viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    shm.setContextProperties(); // Root ctx may change when loading, so redo this
    //viewer.showExpanded();
    viewer.showFullScreen();
    shm.launchSiilihai(false);
    int ret = app.exec();
    viewer.setSource(QUrl("")); // Otherwise things may crash

    // Ugly hack to make sure Siilihai quits graceously after swipe close
    qDebug() << Q_FUNC_INFO << "exec() exited";
    if(!shm.isHaltRequested()) {
        qDebug() << Q_FUNC_INFO << "halt NOT requested yet - forcing halt";
        shm.haltSiilihai();
        app.exec(); // Re-start Qt main loop
    } else {
        qDebug() << Q_FUNC_INFO << "halt ok";
    }
    return ret;
}

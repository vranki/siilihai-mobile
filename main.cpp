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

    app.setQuitOnLastWindowClosed(false); // This does NOT work in SDK currently

    app.connect(&app, SIGNAL(lastWindowClosed()), &shm, SLOT(haltSiilihai()));
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
    // Ugly hack to make sure Siilihai quits graceously after swipe close
    qDebug() << Q_FUNC_INFO << "exec() exited";
    viewer.setSource(QUrl("")); // Otherwise things may crash
    viewer.hide();
    if(!shm.isHaltRequested()) {
        qDebug() << Q_FUNC_INFO << "halt NOT requested yet - forcing halt. This will probably crash on Sailfish";
        shm.haltSiilihai();
        app.exec(); // Re-start Qt main loop
        qDebug() << Q_FUNC_INFO << "Second main loop run exited - all should be good now.";
    } else {
        qDebug() << Q_FUNC_INFO << "Halt ok";
    }
    return ret;
}

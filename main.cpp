#include <QtGui/QApplication>
#include <qdeclarativecontext.h>
#include "qmlapplicationviewer.h"
#include <QGraphicsObject>
#include "siilihaimobile.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());


    viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer->setMainQmlFile(QLatin1String("qml/siilihai-mobile/main.qml"));
    viewer->showExpanded();

    SiilihaiMobile shm(app.data(), viewer->rootContext(), viewer->rootObject());
    shm.launchSiilihai();
    int ret = app->exec();

    // Ugly hack to make sure Siilihai quits graceously
    qDebug() << Q_FUNC_INFO << "exec() exited";
    if(!shm.isHaltRequested()) {
        qDebug() << Q_FUNC_INFO << "halt NOT requested yet - forcing halt";
        shm.haltSiilihai();
        app->exec(); // Re-start Qt main loop
    } else {
        qDebug() << Q_FUNC_INFO << "halt ok";
    }
    return ret;
}

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
    viewer->setMainQmlFile(QLatin1String("qml/siilihaimobile/main.qml"));
    viewer->showExpanded();

    SiilihaiMobile shm(app.data(), viewer->rootContext(), viewer->rootObject());
    shm.launchSiilihai();
    return app->exec();
}

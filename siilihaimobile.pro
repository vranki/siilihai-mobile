# Add more folders to ship with the application, here
folder_01.source = qml/siilihai-mobile
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

TARGET=siilihai-mobile

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE61CB5A8

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon

#CONFIG += link_pkgconfig
CONFIG += qt-boostable qdeclarative-boostable
LIBS += -lmdeclarativecache
INCLUDEPATH += /usr/include/applauncherd
#PKGCONFIG += qdeclarative-boostable

QMAKE_CXXFLAGS += `pkg-config --cflags qdeclarative-boostable`
QMAKE_LFLAGS += `pkg-config --libs qdeclarative-boostable`

# Add dependency to Symbian components
# CONFIG += qt-components

# Always on Harmattan
CONFIG += with_lib

# Use this config flag to build libsiilihai into the binary
CONFIG(with_lib) {
    message(Building WITH lib included in binary!)
    exists("../libsiilihai/src") {
       LIB_PATH = ../libsiilihai
    } else {
       LIB_PATH = libsiilihai
    }
    SOURCES += $$LIB_PATH/src/siilihai/*.cpp
    SOURCES += $$LIB_PATH/src/siilihai/parser/*.cpp
    SOURCES += $$LIB_PATH/src/siilihai/forumdata/*.cpp
    SOURCES += $$LIB_PATH/src/siilihai/forumdatabase/*.cpp
    HEADERS += $$LIB_PATH/src/siilihai/*.h
    SOURCES += $$LIB_PATH/src/siilihai/parser/*.h
    SOURCES += $$LIB_PATH/src/siilihai/forumdata/*.h
    SOURCES += $$LIB_PATH/src/siilihai/forumdatabase/*.h
    INCLUDEPATH += $$LIB_PATH/src/
} else {
    LIBS += -lsiilihai
}

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    siilihaimobile.cpp

QT += network xml webkit


QML_FILES.source = qml
QML_FILES.target = .
#DEPLOYMENTFOLDERS += QML_FILES

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

INSTALLS += binarylibs

HEADERS += \
    siilihaimobile.h

OTHER_FILES += debian/rules \
               debian/control\
               *.desktop \
    android/AndroidManifest.xml \
    android/res/values-ja/strings.xml \
    android/res/values-pt-rBR/strings.xml \
    android/res/values-de/strings.xml \
    android/res/drawable-ldpi/icon.png \
    android/res/values-zh-rCN/strings.xml \
    android/res/values-it/strings.xml \
    android/res/values-el/strings.xml \
    android/res/values-et/strings.xml \
    android/res/values-pl/strings.xml \
    android/res/layout/splash.xml \
    android/res/values-nb/strings.xml \
    android/res/drawable/logo.png \
    android/res/drawable/icon.png \
    android/res/values-rs/strings.xml \
    android/res/values-fr/strings.xml \
    android/res/values-zh-rTW/strings.xml \
    android/res/drawable-mdpi/icon.png \
    android/res/values-ru/strings.xml \
    android/res/values/libs.xml \
    android/res/values/strings.xml \
    android/res/drawable-hdpi/icon.png \
    android/res/values-es/strings.xml \
    android/res/values-id/strings.xml \
    android/res/values-nl/strings.xml \
    android/res/values-fa/strings.xml \
    android/res/values-ro/strings.xml \
    android/res/values-ms/strings.xml \
    android/src/org/kde/necessitas/origo/QtApplication.java \
    android/src/org/kde/necessitas/origo/QtActivity.java \
    android/src/org/kde/necessitas/ministro/IMinistro.aidl \
    android/src/org/kde/necessitas/ministro/IMinistroCallback.aidl \
    android/version.xml

desktops.files = siilihai-mobile.desktop
desktops.path = /usr/share/applications

icons.files = siilihai-mobile.svg
icons.path = /usr/share/icons/hicolor/scalable/apps

INSTALLS += desktops icons

OTHER_FILES += debian/control debian/rules siilihaimobile_harmattan.desktop siilihaimobile.desktop\
debian/changelog

OTHER_FILES += rpm/*.spec rpm/*.changes rpm/prepare_sources.sh

OTHER_FILES += desktops.files

QMAKE_CLEAN += *.o

RESOURCES += \
    siilihai-mobile.qrc

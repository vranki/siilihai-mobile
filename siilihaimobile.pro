# Add more folders to ship with the application, here
#folder_01.source = qml/siilihai-mobile
#folder_01.target = qml
#DEPLOYMENTFOLDERS = folder_01

TARGET=siilihai-mobile

QT += core quick xml network

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic

# Always on
CONFIG += with_lib

# Use this config flag to build libsiilihai into the binary
CONFIG(with_lib) {
    exists("../libsiilihai/src") {
       LIB_PATH = ../libsiilihai
    } else {
       LIB_PATH = libsiilihai
    }
    SOURCES += $$LIB_PATH/src/siilihai/*.cpp
    SOURCES += $$LIB_PATH/src/siilihai/parser/*.cpp
    SOURCES += $$LIB_PATH/src/siilihai/tapatalk/*.cpp
    SOURCES += $$LIB_PATH/src/siilihai/forumdata/*.cpp
    SOURCES += $$LIB_PATH/src/siilihai/forumdatabase/*.cpp
    HEADERS += $$LIB_PATH/src/siilihai/*.h
    HEADERS += $$LIB_PATH/src/siilihai/parser/*.h
    HEADERS += $$LIB_PATH/src/siilihai/tapatalk/*.h
    HEADERS += $$LIB_PATH/src/siilihai/forumdata/*.h
    HEADERS += $$LIB_PATH/src/siilihai/forumdatabase/*.h
    INCLUDEPATH += $$LIB_PATH/src/
    message(Building WITH lib included in binary! Lib source in $$LIB_PATH)
} else {
    LIBS += -lsiilihai
}

#DEFINES += use_components

# Running without components is very WIP
CONFIG(use_components) {
DEFINES += use_components
}

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    siilihaimobile.cpp


QML_FILES.source = qml
QML_FILES.target = .
#DEPLOYMENTFOLDERS += QML_FILES

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
    android/version.xml \
    qml/siilihai-mobile-nocomponents/Toolbar.qml \
    qml/siilihai-mobile-nocomponents/ForumListView.qml \
    qml/siilihai-mobile-nocomponents/ForumButton.qml \
    qml/siilihai-mobile-nocomponents/ToolbarButton.qml \
    qml/siilihai-mobile-nocomponents/GroupListView.qml \
    qml/siilihai-mobile-nocomponents/GroupButton.qml \
    qml/siilihai-mobile-nocomponents/ButtonWithUnreadCount.qml \
    qml/siilihai-mobile-nocomponents/ThreadListView.qml \
    qml/siilihai-mobile-nocomponents/ThreadButton.qml \
    qml/siilihai-mobile-nocomponents/MessageListView.qml \
    qml/siilihai-mobile-nocomponents/MessageDisplay.qml \
    qml/siilihai-mobile-nocomponents/HideEffect.qml \
    qml/siilihai-mobile-nocomponents/widgets/BusyIndicator.qml \
    qml/siilihai-mobile-nocomponents/MessageDialog.qml \
    qml/siilihai-mobile-nocomponents/StatusIndicator.qml \
    qml/siilihai-mobile-nocomponents/widgets/SimpleButton.qml \
    qml/siilihai-mobile-nocomponents/account/LoginWizard.qml \
    qml/siilihai-mobile-nocomponents/forum/SubscribeForumDialog.qml \
    qml/siilihai-mobile-nocomponents/forum/SubscribeForumButton.qml \
    qml/siilihai-mobile-nocomponents/widgets/SimpleTextEdit.qml \
    qml/siilihai-mobile-nocomponents/forum/ForumSettingsDialog.qml \
    qml/siilihai-mobile-nocomponents/forum/GroupSubscriptionButton.qml \
    qml/siilihai-mobile-nocomponents/account/LoginButton.qml \
    qml/siilihai-mobile-nocomponents/account/RegisterButton.qml \
    qml/siilihai-mobile-nocomponents/widgets/SimpleCheckBox.qml \
    qml/siilihai-mobile-nocomponents/forum/SubscribeCustomButton.qml \
    qml/siilihai-mobile-nocomponents/CredentialsDialog.qml \
    qml/siilihai-mobile-nocomponents/UserPassForm.qml \
    qml/siilihai-mobile-nocomponents/SimpleDialog.qml \
    qml/siilihai-mobile-nocomponents/SettingsDialog.qml

desktops.files = siilihai-mobile.desktop
desktops.path = /usr/share/applications

icons.files = siilihai-mobile.svg
icons.path = /usr/share/icons/hicolor/scalable/apps

INSTALLS += desktops icons

OTHER_FILES += qml/siilihai-mobile/* qml/siilihai-mobile-nocomponents/*

OTHER_FILES += debian/control debian/rules siilihaimobile_harmattan.desktop siilihaimobile.desktop debian/changelog

OTHER_FILES += rpm/*.spec rpm/*.changes rpm/*.sh

OTHER_FILES += desktops.files

QMAKE_CLEAN += *.o

RESOURCES += siilihai-mobile.qrc

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

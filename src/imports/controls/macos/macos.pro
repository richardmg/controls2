TARGET = qtquickcontrols2macosstyleplugin
TARGETPATH = QtQuick/Controls.2/macOS
IMPORT_VERSION = 2.1

QT += qml quick
QT_PRIVATE += core-private gui-private qml-private quick-private quicktemplates2-private quickcontrols2-private

CONFIG += no_cxx_module

LIBS += -framework AppKit

DEFINES += QT_NO_CAST_TO_ASCII QT_NO_CAST_FROM_ASCII
DEFINES += INCLUDE_FPS

HEADERS += \
    fps.h \
    qqc2nscontrolimageprovider.h \
    qqc2nscontrol.h

OBJECTIVE_SOURCES += \
    qqc2macosstyleplugin.mm \
    qqc2nscontrolimageprovider.mm \
    qqc2nscontrol.mm

RESOURCES += \
    $$PWD/qtquickcontrols2macosstyleplugin.qrc

OTHER_FILES += \
    qmldir

include(macos.pri)
load(qml_plugin)

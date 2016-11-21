TARGET = qtquickcontrols2macosstyleplugin
TARGETPATH = QtQuick/Controls.2/macOS
IMPORT_VERSION = 2.1

QT += qml quick
QT_PRIVATE += core-private gui-private qml-private quick-private quicktemplates2-private quickcontrols2-private

LIBS += -framework AppKit

DEFINES += QT_NO_CAST_TO_ASCII QT_NO_CAST_FROM_ASCII

OTHER_FILES += \
    qmldir

SOURCES += \
    $$PWD/qtquickcontrols2macosstyleplugin.cpp

RESOURCES += \
    $$PWD/qtquickcontrols2macosstyleplugin.qrc

include(macos.pri)

CONFIG += no_cxx_module
load(qml_plugin)

HEADERS += \
    qquickcontrols2nsview.h

OBJECTIVE_SOURCES += \
    qquickcontrols2nsview.mm

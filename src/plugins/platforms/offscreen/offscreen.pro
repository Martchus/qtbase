TARGET = qoffscreen

QT += \
    core-private gui-private

# Fix linker error when building libqoffscreen.dll by specifying linker flags for
# required modules manually (otherwise order is messed)
LIBS += \
    -lQt5EventDispatcherSupport \
    -lQt5FontDatabaseSupport \
    -lfreetype -lole32 -lgdi32 -luuid
# However, this workaround leads to the necessity of specifying include dirs manually
INCLUDEPATH += \
    $$QT_SOURCE_TREE/include/QtEventDispatcherSupport/$${QT_VERSION} \
    $$QT_SOURCE_TREE/include/QtFontDatabaseSupport/$${QT_VERSION}

DEFINES += QT_NO_FOREACH

SOURCES =   main.cpp \
            qoffscreenintegration.cpp \
            qoffscreenwindow.cpp \
            qoffscreencommon.cpp

HEADERS =   qoffscreenintegration.h \
            qoffscreenwindow.h \
            qoffscreencommon.h

OTHER_FILES += offscreen.json

qtConfig(system-xcb):qtConfig(xlib):qtConfig(opengl):!qtConfig(opengles2) {
    SOURCES += qoffscreenintegration_x11.cpp
    HEADERS += qoffscreenintegration_x11.h
    QT += glx_support-private
    system(echo "Using X11 offscreen integration with GLX")
} else {
    SOURCES += qoffscreenintegration_dummy.cpp
}

PLUGIN_TYPE = platforms
PLUGIN_CLASS_NAME = QOffscreenIntegrationPlugin
!equals(TARGET, $$QT_DEFAULT_QPA_PLUGIN): PLUGIN_EXTENDS = -
load(qt_plugin)

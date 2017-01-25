TARGET = qminimal

QT += \
    core-private gui-private

# Fix linker error when building libqminimal.dll by specifying linker flags for
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
            qminimalintegration.cpp \
            qminimalbackingstore.cpp
HEADERS =   qminimalintegration.h \
            qminimalbackingstore.h

OTHER_FILES += minimal.json

qtConfig(freetype): QMAKE_USE_PRIVATE += freetype

PLUGIN_TYPE = platforms
PLUGIN_CLASS_NAME = QMinimalIntegrationPlugin
!equals(TARGET, $$QT_DEFAULT_QPA_PLUGIN): PLUGIN_EXTENDS = -
load(qt_plugin)

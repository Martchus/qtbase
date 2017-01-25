TARGET = qwindows

QT += core-private gui-private

# Fix linker error when building libqwindows.dll by specifying linker flags for
# required modules manually (otherwise order is messed)
LIBS += \
    -lQt5EventDispatcherSupport \
    -lQt5FontDatabaseSupport \
    -lQt5ThemeSupport \
    -lfreetype -lole32 -lgdi32 -ldwmapi
# However, this workaround leads to the necessity of specifying include dirs manually
INCLUDEPATH += \
    $$QT_SOURCE_TREE/include/QtEventDispatcherSupport/$${QT_VERSION} \
    $$QT_SOURCE_TREE/include/QtFontDatabaseSupport/$${QT_VERSION} \
    $$QT_SOURCE_TREE/include/QtThemeSupport/$${QT_VERSION}
# Same for private support libs for accessibility and vulkan, if those are enabled
qtConfig(accessibility) {
    LIBS += -lQt5AccessibilitySupport
    INCLUDEPATH += $$QT_SOURCE_TREE/include/QtAccessibilitySupport/$${QT_VERSION}
}
qtConfig(vulkan) {
    LIBS += -lQt5VulkanSupport
    INCLUDEPATH += $$QT_SOURCE_TREE/include/QtVulkanSupport/$${QT_VERSION}
}

include(windows.pri)

SOURCES +=  \
    main.cpp \
    qwindowsbackingstore.cpp \
    qwindowsgdiintegration.cpp \
    qwindowsgdinativeinterface.cpp

HEADERS +=  \
    qwindowsbackingstore.h \
    qwindowsgdiintegration.h \
    qwindowsgdinativeinterface.h

OTHER_FILES += windows.json

PLUGIN_TYPE = platforms
PLUGIN_CLASS_NAME = QWindowsIntegrationPlugin
!equals(TARGET, $$QT_DEFAULT_QPA_PLUGIN): PLUGIN_EXTENDS = -
load(qt_plugin)

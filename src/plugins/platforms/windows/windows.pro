TARGET = qwindows

QT += core-private gui-private

# Fix linker error when building libqwindows.dll by specifying linker flags for
# required modules manually (otherwise order is messed)
LIBS += \
    $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5EventDispatcherSupport.$${QMAKE_EXTENSION_STATICLIB} \
    $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5FontDatabaseSupport.$${QMAKE_EXTENSION_STATICLIB} \
    $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5ThemeSupport.$${QMAKE_EXTENSION_STATICLIB} \
    -lfreetype -lole32 -lgdi32 -ldwmapi
# However, this workaround leads to the necessity of specifying include dirs manually
INCLUDEPATH += \
    $$QT_SOURCE_TREE/include/QtEventDispatcherSupport/$${QT_VERSION} \
    $$QT_SOURCE_TREE/include/QtFontDatabaseSupport/$${QT_VERSION} \
    $$QT_SOURCE_TREE/include/QtThemeSupport/$${QT_VERSION}
# Same for private support libs for accessibility and vulkan, if those are enabled
qtConfig(accessibility) {
    LIBS += $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5AccessibilitySupport.$${QMAKE_EXTENSION_STATICLIB}
    INCLUDEPATH += $$QT_SOURCE_TREE/include/QtAccessibilitySupport/$${QT_VERSION}
}
qtConfig(vulkan) {
    LIBS += $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5VulkanSupport.$${QMAKE_EXTENSION_STATICLIB}
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

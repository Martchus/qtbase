TARGET = qdirect2d

QT += \
    core-private gui-private

# Fix linker error when building libqdirect2d.dll by specifying linker flags for
# required modules manually (otherwise order is messed)
LIBS += \
    $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5EventDispatcherSupport.$${QMAKE_EXTENSION_STATICLIB} \
    $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5FontDatabaseSupport.$${QMAKE_EXTENSION_STATICLIB} \
    $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5ThemeSupport.$${QMAKE_EXTENSION_STATICLIB} \
    -lfreetype -lole32 -lgdi32 -luuid
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
# Also add Qt5WindowsUIAutomationSupport - it seems to link against it
LIBS += $$QT_BUILD_TREE/lib/$${QMAKE_PREFIX_STATICLIB}Qt5WindowsUIAutomationSupport.$${QMAKE_EXTENSION_STATICLIB}
INCLUDEPATH += $$QT_SOURCE_TREE/include/Qt5WindowsUIAutomationSupport/$${QT_VERSION}

LIBS += -ldwmapi -lversion
QMAKE_USE_PRIVATE += gdi32 dwrite_1 d2d1_1 d3d11_1 dxgi1_2

include(../windows/windows.pri)

SOURCES += \
    qwindowsdirect2dpaintengine.cpp \
    qwindowsdirect2dpaintdevice.cpp \
    qwindowsdirect2dplatformpixmap.cpp \
    qwindowsdirect2dcontext.cpp \
    qwindowsdirect2dbitmap.cpp \
    qwindowsdirect2dbackingstore.cpp \
    qwindowsdirect2dintegration.cpp \
    qwindowsdirect2dplatformplugin.cpp \
    qwindowsdirect2ddevicecontext.cpp \
    qwindowsdirect2dnativeinterface.cpp \
    qwindowsdirect2dwindow.cpp

HEADERS += \
    qwindowsdirect2dpaintengine.h \
    qwindowsdirect2dpaintdevice.h \
    qwindowsdirect2dplatformpixmap.h \
    qwindowsdirect2dcontext.h \
    qwindowsdirect2dhelpers.h \
    qwindowsdirect2dbitmap.h \
    qwindowsdirect2dbackingstore.h \
    qwindowsdirect2dintegration.h \
    qwindowsdirect2ddevicecontext.h \
    qwindowsdirect2dnativeinterface.h \
    qwindowsdirect2dwindow.h

OTHER_FILES += direct2d.json

PLUGIN_TYPE = platforms
PLUGIN_CLASS_NAME = QWindowsDirect2DIntegrationPlugin
!equals(TARGET, $$QT_DEFAULT_QPA_PLUGIN): PLUGIN_EXTENDS = -
load(qt_plugin)

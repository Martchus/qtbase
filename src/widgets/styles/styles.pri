# Qt styles module

HEADERS += \
        styles/qdrawutil.h \
        styles/qstyle.h \
        styles/qstyleanimation_p.h \
        styles/qstylefactory.h \
        styles/qstyleoption.h \
        styles/qstyleplugin.h \
        styles/qcommonstylepixmaps_p.h \
        styles/qcommonstyle.h \
        styles/qstylehelper_p.h \
        styles/qproxystyle.h \
        styles/qproxystyle_p.h \
        styles/qcommonstyle_p.h \
        styles/qstylepainter.h \
        styles/qstylesheetstyle_p.h \
        styles/qpixmapstyle_p.h \
        styles/qpixmapstyle_p_p.h

SOURCES += \
        styles/qdrawutil.cpp \
        styles/qstyle.cpp \
        styles/qstyleanimation.cpp \
        styles/qstylefactory.cpp \
        styles/qstyleoption.cpp \
        styles/qstyleplugin.cpp \
        styles/qstylehelper.cpp \
        styles/qcommonstyle.cpp \
        styles/qproxystyle.cpp \
        styles/qstylepainter.cpp \
        styles/qstylesheetstyle.cpp \
        styles/qstylesheetstyle_default.cpp \
        styles/qpixmapstyle.cpp

RESOURCES += styles/qstyle.qrc

include($$OUT_PWD/qtwidgets-config.pri)

qtConfig(style-mac) {
    HEADERS += \
        styles/qmacstyle_mac_p.h \
        styles/qmacstyle_mac_p_p.h
    OBJECTIVE_SOURCES += styles/qmacstyle_mac.mm
    LIBS_PRIVATE += -framework Carbon
    DEFINES += NS_BUILD_32_LIKE_64
}

qtConfig(style-windowsvista) {
    HEADERS += styles/qwindowsvistastyle_p.h styles/qwindowsvistastyle_p_p.h
    SOURCES += styles/qwindowsvistastyle.cpp
}

qtConfig(style-windowsxp) {
    HEADERS += styles/qwindowsxpstyle_p.h styles/qwindowsxpstyle_p_p.h
    SOURCES += styles/qwindowsxpstyle.cpp
}

qtConfig(style-windows) {
    HEADERS += styles/qwindowsstyle_p.h styles/qwindowsstyle_p_p.h
    SOURCES += styles/qwindowsstyle.cpp
}

qtConfig(style-fusion) {
    HEADERS += styles/qfusionstyle_p.h styles/qfusionstyle_p_p.h
    SOURCES += styles/qfusionstyle.cpp
}

qtConfig(style-android) {
    HEADERS += styles/qandroidstyle_p.h
    SOURCES += styles/qandroidstyle.cpp
}

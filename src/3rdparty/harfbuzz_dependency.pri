contains(QT_CONFIG, harfbuzz) {
    INCLUDEPATH += $$PWD/harfbuzz-ng/include
    LIBS_PRIVATE += -L$$QT_BUILD_TREE/lib -lqtharfbuzzng$$qtPlatformTargetSuffix()
} else:contains(QT_CONFIG, system-harfbuzz) {
    # can't use 'feature' link_pkgconfig here because it would add harfbuzz to LIBS rather than LIBS_PRIVATE
    contains(QT_CONFIG, static): LIBS_PRIVATE += $$system($$PKG_CONFIG --static --libs harfbuzz)
    else: LIBS_PRIVATE += $$system($$PKG_CONFIG --libs harfbuzz)
}

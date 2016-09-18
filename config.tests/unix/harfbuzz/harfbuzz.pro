SOURCES = harfbuzz.cpp
CONFIG -= qt dylib
contains(CONFIG, static): LIBS += $$system($$PKG_CONFIG --static --libs harfbuzz)
else: LIBS += $$system($$PKG_CONFIG --libs harfbuzz)

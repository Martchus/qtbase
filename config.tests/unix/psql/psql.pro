SOURCES = psql.cpp
CONFIG -= qt dylib
contains(CONFIG, static) {
    LIBS *= -lpq -lintl -liconv -lssl -lcrypto -lwldap32 -lshfolder -lwsock32 -lws2_32 -lsecur32 -lgdi32
} else {
    LIBS *= -lpq
}

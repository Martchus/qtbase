SOURCES = mysql.cpp
CONFIG -= qt dylib
contains(CONFIG, static) {
    LIBS += -lmariadbclient -lws2_32 -lpthread -lz -lm -lssl -lcrypto
} else {
    LIBS += -lmariadbclient
}

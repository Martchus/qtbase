# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: BSD-3-Clause

qt_internal_add_plugin(QNLMNIPlugin
    OUTPUT_NAME qnetworklistmanager
    CLASS_NAME QNetworkListManagerNetworkInformationBackendFactory
    PLUGIN_TYPE networkinformation
    DEFAULT_IF WIN32 AND QT_FEATURE_networklistmanager
    EXCEPTIONS
    SOURCES
        qnetworklistmanagernetworkinformationbackend.cpp
        qnetworklistmanagerevents.h qnetworklistmanagerevents.cpp
    LIBRARIES
        Qt::NetworkPrivate
)

qt_internal_extend_target(QNLMNIPlugin CONDITION WIN32
    LIBRARIES
        runtimeobject
        oleaut32
)

# workaround undefined reference to `__sync_bool_compare_and_swap_16'
if (QT_FEATURE_cpp_winrt AND MINGW AND CMAKE_SIZEOF_VOID_P EQUAL 8 AND CMAKE_SYSTEM_PROCESSOR MATCHES "(x86.*)|(X86.*)|(amd64)|(AMD64)")
    target_compile_options(QNLMNIPlugin PRIVATE -mcx16)
endif ()

# Don't repeat the target name in AUTOGEN_BUILD_DIR to work around issues with overlong paths.
set_property(TARGET QNLMNIPlugin PROPERTY
    AUTOGEN_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/autogen")

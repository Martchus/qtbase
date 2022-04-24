find_package(PkgConfig QUIET)

if(NOT TARGET PkgConfig::Fontconfig)
    pkg_check_modules(Fontconfig fontconfig IMPORTED_TARGET)

    if (NOT TARGET PkgConfig::Fontconfig)
        set(Fontconfig_FOUND 0)
    endif()
else()
    set(Fontconfig_FOUND 1)
endif()

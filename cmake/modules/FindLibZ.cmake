# try to find libz API, once done this will define 
#
# LIBZ_FOUND       - system has libz 
# LIBZ_INCLUDE_DIR - the libz include directory 
# LIBZ_LIBRARY     - the filepath of libz library
# LIBZ_VERSION     - the version  of libz library


if (LIBZ_INCLUDE_DIR AND LIBZ_LIBRARY)
    set(LIBZ_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_LIBZ QUIET zlib)

    #message("PKG_CONFIG_LIBZ_FOUND=${PKG_CONFIG_LIBZ_FOUND}")
    #message("PKG_CONFIG_LIBZ_INCLUDE_DIRS=${PKG_CONFIG_LIBZ_INCLUDE_DIRS}")
    #message("PKG_CONFIG_LIBZ_LIBRARY_DIRS=${PKG_CONFIG_LIBZ_LIBRARY_DIRS}")
    #message("PKG_CONFIG_LIBZ_INCLUDEDIR=${PKG_CONFIG_LIBZ_INCLUDEDIR}")
    #message("PKG_CONFIG_LIBZ_LIBDIR=${PKG_CONFIG_LIBZ_LIBDIR}")
    #message("PKG_CONFIG_LIBZ_VERSION=${PKG_CONFIG_LIBZ_VERSION}")
     
    if (ENABLE_STATIC)
        set(LIBZ_LIBRARY_NAMES libz.a z)
    else()
        set(LIBZ_LIBRARY_NAMES z)
    endif()

    if (PKG_CONFIG_LIBZ_FOUND)
        find_path(   LIBZ_INCLUDE_DIR   zlib.h                HINTS ${PKG_CONFIG_LIBZ_INCLUDE_DIRS})
        find_library(LIBZ_LIBRARY NAMES ${LIBZ_LIBRARY_NAMES} HINTS ${PKG_CONFIG_LIBZ_LIBRARY_DIRS})
    else()
        find_path(   LIBZ_INCLUDE_DIR       zlib.h)
        find_library(LIBZ_LIBRARY     NAMES ${LIBZ_LIBRARY_NAMES})
    endif()

    if (LIBZ_INCLUDE_DIR AND LIBZ_LIBRARY)
        if (PKG_CONFIG_LIBZ_VERSION)
            set(LIBZ_VERSION ${PKG_CONFIG_LIBZ_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    LibZ
    FOUND_VAR LIBZ_FOUND
    REQUIRED_VARS LIBZ_LIBRARY LIBZ_INCLUDE_DIR
    VERSION_VAR LIBZ_VERSION
)

mark_as_advanced(LIBZ_INCLUDE_DIR LIBZ_LIBRARY)

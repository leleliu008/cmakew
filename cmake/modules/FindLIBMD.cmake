# try to find libmd, once done following variables will be defined
#
# LIBMD_FOUND       - system has libmd
# LIBMD_VERSION     - the version of libmd
# LIBMD_INCLUDE_DIR - the libmd include directory
# LIBMD_LIBRARY     - the filepath of libmd.a|so|dylib


if (LIBMD_INCLUDE_DIR AND LIBMD_LIBRARY)
    set(LIBMD_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_LIBZ QUIET libmd)

    #message("PKG_CONFIG_LIBMD_FOUND=${PKG_CONFIG_LIBMD_FOUND}")
    #message("PKG_CONFIG_LIBMD_INCLUDE_DIRS=${PKG_CONFIG_LIBMD_INCLUDE_DIRS}")
    #message("PKG_CONFIG_LIBMD_LIBRARY_DIRS=${PKG_CONFIG_LIBMD_LIBRARY_DIRS}")
    #message("PKG_CONFIG_LIBMD_INCLUDEDIR=${PKG_CONFIG_LIBMD_INCLUDEDIR}")
    #message("PKG_CONFIG_LIBMD_LIBDIR=${PKG_CONFIG_LIBMD_LIBDIR}")
    #message("PKG_CONFIG_LIBMD_VERSION=${PKG_CONFIG_LIBMD_VERSION}")
     
    if (ENABLE_STATIC)
        set(LIBMD_LIBRARY_NAMES libmd.a md)
    else()
        set(LIBMD_LIBRARY_NAMES md)
    endif()

    if (PKG_CONFIG_LIBMD_FOUND)
        find_path   (LIBMD_INCLUDE_DIR   sha256.h               HINTS ${PKG_CONFIG_LIBMD_INCLUDE_DIRS})
        find_library(LIBMD_LIBRARY NAMES ${LIBMD_LIBRARY_NAMES} HINTS ${PKG_CONFIG_LIBMD_LIBRARY_DIRS})
    else()
        find_path   (LIBMD_INCLUDE_DIR   sha256.h)
        find_library(LIBMD_LIBRARY NAMES ${LIBMD_LIBRARY_NAMES})
    endif()

    if (LIBMD_INCLUDE_DIR AND LIBMD_LIBRARY)
        if (PKG_CONFIG_LIBMD_VERSION)
            set(LIBMD_VERSION ${PKG_CONFIG_LIBMD_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    LIBMD
    FOUND_VAR LIBMD_FOUND
    REQUIRED_VARS LIBMD_LIBRARY LIBMD_INCLUDE_DIR
    VERSION_VAR LIBMD_VERSION
)

mark_as_advanced(LIBMD_INCLUDE_DIR LIBMD_LIBRARY)

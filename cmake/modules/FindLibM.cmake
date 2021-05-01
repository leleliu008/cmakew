# try to find libm, once done following variables will be defined
#
# LIBM_FOUND       - system has libm
# LIBM_VERSION     - the version of libm
# LIBM_INCLUDE_DIR - the libm include directory
# LIBM_LIBRARY     - the filepath of libm.a|so|dylib


if (LIBM_INCLUDE_DIR AND LIBM_LIBRARY)
    set(LIBM_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_LIBM QUIET libm)

    #message("PKG_CONFIG_LIBM_FOUND=${PKG_CONFIG_LIBM_FOUND}")
    #message("PKG_CONFIG_LIBM_INCLUDE_DIRS=${PKG_CONFIG_LIBM_INCLUDE_DIRS}")
    #message("PKG_CONFIG_LIBM_LIBRARY_DIRS=${PKG_CONFIG_LIBM_LIBRARY_DIRS}")
    #message("PKG_CONFIG_LIBM_INCLUDEDIR=${PKG_CONFIG_LIBM_INCLUDEDIR}")
    #message("PKG_CONFIG_LIBM_LIBDIR=${PKG_CONFIG_LIBM_LIBDIR}")
    #message("PKG_CONFIG_LIBM_VERSION=${PKG_CONFIG_LIBM_VERSION}")
     
    if (ENABLE_STATIC)
        set(LIBM_LIBRARY_NAMES libm.a m c)
    else()
        set(LIBM_LIBRARY_NAMES m c)
    endif()

    if (PKG_CONFIG_LIBM_FOUND)
        find_path   (LIBM_INCLUDE_DIR   math.h                HINTS ${PKG_CONFIG_LIBM_INCLUDE_DIRS})
        find_library(LIBM_LIBRARY NAMES ${LIBM_LIBRARY_NAMES} HINTS ${PKG_CONFIG_LIBM_LIBRARY_DIRS})
    else()
        find_path   (LIBM_INCLUDE_DIR   math.h)
        find_library(LIBM_LIBRARY NAMES ${LIBM_LIBRARY_NAMES})
    endif()

    if (LIBM_INCLUDE_DIR AND LIBM_LIBRARY)
        if (PKG_CONFIG_LIBM_VERSION)
            set(LIBM_VERSION ${PKG_CONFIG_LIBM_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    LIBM
    FOUND_VAR LIBM_FOUND
    REQUIRED_VARS LIBM_LIBRARY LIBM_INCLUDE_DIR
    VERSION_VAR LIBM_VERSION
)

mark_as_advanced(LIBM_INCLUDE_DIR LIBM_LIBRARY)

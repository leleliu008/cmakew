# try to find libdl, once done following variables will be defined
#
# LIBDL_FOUND       - system has libdl
# LIBDL_VERSION     - the version of libdl
# LIBDL_INCLUDE_DIR - the libdl include directory
# LIBDL_LIBRARY     - the filepath of libdl.a|so|dylib


if (LIBDL_INCLUDE_DIR AND LIBDL_LIBRARY)
    set(LIBDL_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_LIBZ QUIET zlib)

    #message("PKG_CONFIG_LIBDL_FOUND=${PKG_CONFIG_LIBDL_FOUND}")
    #message("PKG_CONFIG_LIBDL_INCLUDE_DIRS=${PKG_CONFIG_LIBDL_INCLUDE_DIRS}")
    #message("PKG_CONFIG_LIBDL_LIBRARY_DIRS=${PKG_CONFIG_LIBDL_LIBRARY_DIRS}")
    #message("PKG_CONFIG_LIBDL_INCLUDEDIR=${PKG_CONFIG_LIBDL_INCLUDEDIR}")
    #message("PKG_CONFIG_LIBDL_LIBDIR=${PKG_CONFIG_LIBDL_LIBDIR}")
    #message("PKG_CONFIG_LIBDL_VERSION=${PKG_CONFIG_LIBDL_VERSION}")
     
    if (ENABLE_STATIC)
        set(LIBDL_LIBRARY_NAMES dl)
    else()
        set(LIBDL_LIBRARY_NAMES dl)
    endif()

    if (PKG_CONFIG_LIBDL_FOUND)
        find_path   (LIBDL_INCLUDE_DIR   dlfcn.h                HINTS ${PKG_CONFIG_LIBDL_INCLUDE_DIRS})
        find_library(LIBDL_LIBRARY NAMES ${LIBDL_LIBRARY_NAMES} HINTS ${PKG_CONFIG_LIBDL_LIBRARY_DIRS})
    else()
        find_path   (LIBDL_INCLUDE_DIR   dlfcn.h)
        find_library(LIBDL_LIBRARY NAMES ${LIBDL_LIBRARY_NAMES})
    endif()

    if (LIBDL_INCLUDE_DIR AND LIBDL_LIBRARY)
        if (PKG_CONFIG_LIBDL_VERSION)
            set(LIBDL_VERSION ${PKG_CONFIG_LIBDL_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    LIBDL
    FOUND_VAR LIBDL_FOUND
    REQUIRED_VARS LIBDL_LIBRARY LIBDL_INCLUDE_DIR
    VERSION_VAR LIBDL_VERSION
)

mark_as_advanced(LIBDL_INCLUDE_DIR LIBDL_LIBRARY)

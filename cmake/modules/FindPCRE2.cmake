# try to find libpcre2, once done following variables will be defined
#
# PCRE2_FOUND       - system has libpcre2
# PCRE2_VERSION     - the version of libpcre2
# PCRE2_INCLUDE_DIR - the libpcre2 include directory
# PCRE2_LIBRARY     - the libpcre2-8.a/.so/.dylib

if (NOT PCRE2_BIT)
    set(PCRE2_BIT 8)
endif()

if (PCRE2_INCLUDE_DIR AND PCRE2_LIBRARY)
    set(PCRE2_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_PCRE2 QUIET libpcre2-${PCRE2_BIT})

    #message("PKG_CONFIG_PCRE2_FOUND=${PKG_CONFIG_PCRE2_FOUND}")
    #message("PKG_CONFIG_PCRE2_INCLUDE_DIRS=${PKG_CONFIG_PCRE2_INCLUDE_DIRS}")
    #message("PKG_CONFIG_PCRE2_LIBRARY_DIRS=${PKG_CONFIG_PCRE2_LIBRARY_DIRS}")
    #message("PKG_CONFIG_PCRE2_INCLUDEDIR=${PKG_CONFIG_PCRE2_INCLUDEDIR}")
    #message("PKG_CONFIG_PCRE2_LIBDIR=${PKG_CONFIG_PCRE2_LIBDIR}")
    #message("PKG_CONFIG_PCRE2_VERSION=${PKG_CONFIG_PCRE2_VERSION}")

    if (ENABLE_STATIC)
        set(PCRE2_LIBRARY_NAMES libpcre2-${PCRE2_BIT}.a)
    else()
        set(PCRE2_LIBRARY_NAMES pcre2-${PCRE2_BIT})
    endif()

    if (PKG_CONFIG_PCRE2_FOUND)
        find_path(PCRE2_INCLUDE_DIR pcre2.h HINTS ${PKG_CONFIG_PCRE2_INCLUDE_DIRS})
        find_library(PCRE2_LIBRARY  ${PCRE2_LIBRARY_NAMES} HINTS ${PKG_CONFIG_PCRE2_LIBRARY_DIRS})
        if (PKG_CONFIG_PCRE2_VERSION)
            set(PCRE2_VERSION ${PKG_CONFIG_PCRE2_VERSION})
        endif()
    else()
        find_path(PCRE2_INCLUDE_DIR pcre2.h)
        find_library(PCRE2_LIBRARY  ${PCRE2_LIBRARY_NAMES})
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PCRE2 REQUIRED_VARS PCRE2_LIBRARY PCRE2_INCLUDE_DIR VERSION_VAR PCRE2_VERSION)

mark_as_advanced(PCRE2_INCLUDE_DIR PCRE2_LIBRARY)

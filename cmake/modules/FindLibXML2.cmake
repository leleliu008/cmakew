# try to find libxml/*.h API, once done this will define
#
# LIBXML2_FOUND       - system has libxml2
# LIBXML2_INCLUDE_DIR - the libxml2 include directory
# LIBXML2_LIBRARY     - the filepath of libxml2 library
# LIBXML2_VERSION     - the version  of libxml2 library


if (LIBXML2_INCLUDE_DIR AND LIBXML2_LIBRARY)
    set(LIBXML2_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_LIBXML2 QUIET libxml-2.0)

    #message("PKG_CONFIG_LIBXML2_FOUND=${PKG_CONFIG_LIBXML2_FOUND}")
    #message("PKG_CONFIG_LIBXML2_INCLUDE_DIRS=${PKG_CONFIG_LIBXML2_INCLUDE_DIRS}")
    #message("PKG_CONFIG_LIBXML2_LIBRARY_DIRS=${PKG_CONFIG_LIBXML2_LIBRARY_DIRS}")
    #message("PKG_CONFIG_LIBXML2_INCLUDEDIR=${PKG_CONFIG_LIBXML2_INCLUDEDIR}")
    #message("PKG_CONFIG_LIBXML2_LIBDIR=${PKG_CONFIG_LIBXML2_LIBDIR}")
    #message("PKG_CONFIG_LIBXML2_VERSION=${PKG_CONFIG_LIBXML2_VERSION}")

    if(ENABLE_STATIC)
        set(LIBXML2_LIBRARY_NAMES libxml2.a)
    else()
        set(LIBXML2_LIBRARY_NAMES xml2)
    endif()

    if (PKG_CONFIG_LIBXML2_FOUND)
        find_path(LIBXML2_INCLUDE_DIR libxml/SAX2.h            HINTS ${PKG_CONFIG_LIBXML2_INCLUDE_DIRS})
        find_library(LIBXML2_LIBRARY  ${LIBXML2_LIBRARY_NAMES} HINTS ${PKG_CONFIG_LIBXML2_LIBRARY_DIRS})
    else()
        find_path(LIBXML2_INCLUDE_DIR libxml/SAX2.h)
        find_library(LIBXML2_LIBRARY  ${LIBXML2_LIBRARY_NAMES})
    endif()
    
    if (PKG_CONFIG_LIBXML2_VERSION)
        set(LIBXML2_VERSION ${PKG_CONFIG_LIBXML2_VERSION})
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibXML2 REQUIRED_VARS LIBXML2_LIBRARY LIBXML2_INCLUDE_DIR VERSION_VAR LIBXML2_VERSION)

mark_as_advanced(LIBXML2_INCLUDE_DIR LIBXML2_LIBRARY)

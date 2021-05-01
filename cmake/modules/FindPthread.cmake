# try to find pthread API, once done this will define 
#
# PTHREAD_FOUND       - system has pthread 
# PTHREAD_INCLUDE_DIR - the pthread include directory 
# PTHREAD_LIBRARY     - the filepath of pthread library
# PTHREAD_VERSION     - the version  of pthread library


if (PTHREAD_INCLUDE_DIR AND PTHREAD_LIBRARY)
    set(PTHREAD_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_PTHREAD QUIET pthread)

    #message("PKG_CONFIG_PTHREAD_FOUND=${PKG_CONFIG_PTHREAD_FOUND}")
    #message("PKG_CONFIG_PTHREAD_INCLUDE_DIRS=${PKG_CONFIG_PTHREAD_INCLUDE_DIRS}")
    #message("PKG_CONFIG_PTHREAD_LIBRARY_DIRS=${PKG_CONFIG_PTHREAD_LIBRARY_DIRS}")
    #message("PKG_CONFIG_PTHREAD_INCLUDEDIR=${PKG_CONFIG_PTHREAD_INCLUDEDIR}")
    #message("PKG_CONFIG_PTHREAD_LIBDIR=${PKG_CONFIG_PTHREAD_LIBDIR}")
    #message("PKG_CONFIG_PTHREAD_VERSION=${PKG_CONFIG_PTHREAD_VERSION}")
     
    if (ENABLE_STATIC)
        set(PTHREAD_LIBRARY_NAMES libpthread.a pthread)
    else()
        set(PTHREAD_LIBRARY_NAMES pthread)
    endif()

    if (PKG_CONFIG_PTHREAD_FOUND)
        find_path(   PTHREAD_INCLUDE_DIR   pthread.h                HINTS ${PKG_CONFIG_PTHREAD_INCLUDE_DIRS})
        find_library(PTHREAD_LIBRARY NAMES ${PTHREAD_LIBRARY_NAMES} HINTS ${PKG_CONFIG_PTHREAD_LIBRARY_DIRS})
    else()
        find_path(   PTHREAD_INCLUDE_DIR   pthread.h)
        find_library(PTHREAD_LIBRARY NAMES ${PTHREAD_LIBRARY_NAMES})
    endif()

    if (PTHREAD_INCLUDE_DIR AND PTHREAD_LIBRARY)
        if (PKG_CONFIG_PTHREAD_VERSION)
            set(PTHREAD_VERSION ${PKG_CONFIG_PTHREAD_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    Pthread
    FOUND_VAR PTHREAD_FOUND
    REQUIRED_VARS PTHREAD_LIBRARY PTHREAD_INCLUDE_DIR
    VERSION_VAR PTHREAD_VERSION
)

mark_as_advanced(PTHREAD_INCLUDE_DIR PTHREAD_LIBRARY)

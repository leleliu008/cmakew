# try to find liblzma API, once done this will define 
#
# LIBLZMA_FOUND       - system has liblzma 
# LIBLZMA_INCLUDE_DIR - the liblzma include directory 
# LIBLZMA_LIBRARY     - the filepath of liblzma library
# LIBLZMA_VERSION     - the version  of liblzma library


if (LIBLZMA_INCLUDE_DIR AND LIBLZMA_LIBRARY)
    set(LIBLZMA_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_LIBLZMA QUIET liblzma)

    message("PKG_CONFIG_LIBLZMA_FOUND=${PKG_CONFIG_LIBLZMA_FOUND}")
    message("PKG_CONFIG_LIBLZMA_INCLUDE_DIRS=${PKG_CONFIG_LIBLZMA_INCLUDE_DIRS}")
    message("PKG_CONFIG_LIBLZMA_LIBRARY_DIRS=${PKG_CONFIG_LIBLZMA_LIBRARY_DIRS}")
    message("PKG_CONFIG_LIBLZMA_INCLUDEDIR=${PKG_CONFIG_LIBLZMA_INCLUDEDIR}")
    message("PKG_CONFIG_LIBLZMA_LIBDIR=${PKG_CONFIG_LIBLZMA_LIBDIR}")
    message("PKG_CONFIG_LIBLZMA_VERSION=${PKG_CONFIG_LIBLZMA_VERSION}")
    message("PKG_CONFIG_LIBLZMA_LIBRARIES=${PKG_CONFIG_LIBLZMA_LIBRARIES}")
    message("PKG_CONFIG_LIBLZMA_STATIC_LIBRARIES=${PKG_CONFIG_LIBLZMA_STATIC_LIBRARIES}")
     
    if (ENABLE_STATIC)
        set(LIBLZMA_LIBRARY_NAMES liblzma.a lzma)
    else()
        set(LIBLZMA_LIBRARY_NAMES lzma)
    endif()

    if (PKG_CONFIG_LIBLZMA_FOUND)
        find_path   (LIBLZMA_INCLUDE_DIR   lzma.h                   HINTS ${PKG_CONFIG_LIBLZMA_INCLUDE_DIRS})
        find_library(LIBLZMA_LIBRARY NAMES ${LIBLZMA_LIBRARY_NAMES} HINTS ${PKG_CONFIG_LIBLZMA_LIBRARY_DIRS})
    else()
        find_path   (LIBLZMA_INCLUDE_DIR   lzma.h)
        find_library(LIBLZMA_LIBRARY NAMES ${LIBLZMA_LIBRARY_NAMES})
    endif()

    if (LIBLZMA_INCLUDE_DIR AND LIBLZMA_LIBRARY)
        if (PKG_CONFIG_LIBLZMA_VERSION)
            set(LIBLZMA_VERSION ${PKG_CONFIG_LIBLZMA_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    LibLZMA
    FOUND_VAR LIBLZMA_FOUND
    REQUIRED_VARS LIBLZMA_LIBRARY LIBLZMA_INCLUDE_DIR
    VERSION_VAR LIBLZMA_VERSION
)

mark_as_advanced(LIBLZMA_INCLUDE_DIR LIBLZMA_LIBRARY)

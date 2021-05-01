# try to find liblzma , once done following variables will be defined
#
# LIBLZMA_FOUND        - system has liblzma
# LIBLZMA_VERSION      - the version of liblzma
#
# LIBLZMA_INCLUDE_DIR  - the liblzma include directory
# LIBLZMA_LIBRARY      - the filepath of liblzma library
#
# LIBLZMA_INCLUDE_DIRS - the liblzma include directory   and it's dependencies's include directory 
# LIBLZMA_LIBRARY_LIST - the filepath of liblzma library and it's dependencies's


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

    set(LIBLZMA_INCLUDE_DIR)
    set(LIBLZMA_LIBRARY)

    set(LIBLZMA_INCLUDE_DIRS)
    set(LIBLZMA_LIBRARY_LIST)
     
    if (ENABLE_STATIC)
        if (PKG_CONFIG_LIBLZMA_FOUND)
            foreach(item ${PKG_CONFIG_LIBLZMA_STATIC_LIBRARIES})
                if (item STREQUAL "lzma")
                    find_path   (LIBLZMA_INCLUDE_DIR   lzma.h         HINTS ${PKG_CONFIG_LIBLZMA_INCLUDE_DIRS})
                    find_library(LIBLZMA_LIBRARY NAMES liblzma.a lzma HINTS ${PKG_CONFIG_LIBLZMA_LIBRARY_DIRS})
                elseif (item STREQUAL "md")
                    find_package(LIBMD)
                    if (LIBMD_FOUND)
                        list(APPEND LIBLZMA_INCLUDE_DIRS ${LIBMD_INCLUDE_DIR})
                        list(APPEND LIBLZMA_LIBRARY_LIST ${LIBMD_LIBRARY})
                    endif()
                endif()
        endforeach()
        else()
            find_path   (LIBLZMA_INCLUDE_DIR   lzma.h)
            find_library(LIBLZMA_LIBRARY NAMES liblzma.a lzma)
        endif()
    else()
        if (PKG_CONFIG_LIBLZMA_FOUND)
            find_path   (LIBLZMA_INCLUDE_DIR   lzma.h HINTS ${PKG_CONFIG_LIBLZMA_INCLUDE_DIRS})
            find_library(LIBLZMA_LIBRARY NAMES lzma   HINTS ${PKG_CONFIG_LIBLZMA_LIBRARY_DIRS})
        else()
            find_path   (LIBLZMA_INCLUDE_DIR   lzma.h)
            find_library(LIBLZMA_LIBRARY NAMES lzma)
        endif()
    endif()


    if (LIBLZMA_INCLUDE_DIR AND LIBLZMA_LIBRARY)
        list(INSERT LIBLZMA_INCLUDE_DIRS 0 ${LIBLZMA_INCLUDE_DIR})
        list(INSERT LIBLZMA_LIBRARY_LIST 0 ${LIBLZMA_LIBRARY})
        if (PKG_CONFIG_LIBLZMA_VERSION)
            set(LIBLZMA_VERSION ${PKG_CONFIG_LIBLZMA_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    LIBLZMA
    FOUND_VAR LIBLZMA_FOUND
    REQUIRED_VARS LIBLZMA_LIBRARY LIBLZMA_INCLUDE_DIR
    VERSION_VAR LIBLZMA_VERSION
)

mark_as_advanced(LIBLZMA_INCLUDE_DIR LIBLZMA_LIBRARY)

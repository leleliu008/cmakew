# try to find libxml/*.h API, once done this will define
#
# LIBXML2_FOUND        - system has libxml2
# LIBXML2_INCLUDE_DIRS - the libxml2 include directory  and it's dependencies's include directory
# LIBXML2_LIBRARY_LIST - the filepath of libxml2 library and it's dependencies's library
# LIBXML2_VERSION      - the version  of libxml2 library


if (LIBXML2_INCLUDE_DIRS AND LIBXML2_LIBRARY_LIST)
    set(LIBXML2_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_LIBXML2 QUIET libxml-2.0)

    message("PKG_CONFIG_LIBXML2_FOUND=${PKG_CONFIG_LIBXML2_FOUND}")
    message("PKG_CONFIG_LIBXML2_INCLUDE_DIRS=${PKG_CONFIG_LIBXML2_INCLUDE_DIRS}")
    message("PKG_CONFIG_LIBXML2_LIBRARY_DIRS=${PKG_CONFIG_LIBXML2_LIBRARY_DIRS}")
    message("PKG_CONFIG_LIBXML2_INCLUDEDIR=${PKG_CONFIG_LIBXML2_INCLUDEDIR}")
    message("PKG_CONFIG_LIBXML2_LIBDIR=${PKG_CONFIG_LIBXML2_LIBDIR}")
    message("PKG_CONFIG_LIBXML2_VERSION=${PKG_CONFIG_LIBXML2_VERSION}")
    message("PKG_CONFIG_LIBXML2_LDFLAGS=${PKG_CONFIG_LIBXML2_LDFLAGS}")
    message("PKG_CONFIG_LIBXML2_LDFLAGS_OTHER=${PKG_CONFIG_LIBXML2_LDFLAGS_OTHER}")
    message("PKG_CONFIG_LIBXML2_STATIC_LIBRARIES=${PKG_CONFIG_LIBXML2_STATIC_LIBRARIES}")

    if (ENABLE_STATIC)
        if (PKG_CONFIG_LIBXML2_FOUND)
            foreach (item ${PKG_CONFIG_LIBXML2_STATIC_LIBRARIES})
                if  (item STREQUAL "xml2")
                    find_path   (LIBXML2_INCLUDE_DIRS libxml/SAX2.h HINTS ${PKG_CONFIG_LIBXML2_INCLUDE_DIRS})
                    find_library(LIBXML2_LIBRARY_LIST libxml2.a     HINTS ${PKG_CONFIG_LIBXML2_LIBRARY_DIRS})
                elseif (item STREQUAL "m")
                    list(APPEND LIBXML2_LIBRARY_LIST -lm)
                elseif (item STREQUAL "z")
                    find_package(LibZ)
                    if (LIBZ_FOUND)
                        set(HAVE_LIBZ 1)
                        list(APPEND LIBXML2_INCLUDE_DIRS ${LIBZ_INCLUDE_DIR})
                        list(APPEND LIBXML2_LIBRARY_LIST ${LIBZ_LIBRARY})
                    endif()
                elseif (item STREQUAL "lzma")
                    find_package(LibLZMA)
                    if (LIBLZMA_FOUND)
                        set(HAVE_LIBLZMA 1)
                        list(APPEND LIBXML2_INCLUDE_DIRS ${LIBLZMA_INCLUDE_DIR})
                        list(APPEND LIBXML2_LIBRARY_LIST ${LIBLZMA_LIBRARY})
                    endif()
                elseif (item STREQUAL "iconv")
                    find_package(Iconv)
                    if (ICONV_FOUND)
                        set(HAVE_ICONV 1)
                        list(APPEND LIBXML2_INCLUDE_DIRS ${ICONV_INCLUDE_DIR})
                        list(APPEND LIBXML2_LIBRARY_LIST ${ICONV_LIBRARY})
                    endif()
                elseif (item STREQUAL "pthread")
                    if (CMAKE_SYSTEM_NAME STREQUAL "Android")
                        message("for Android System")
                    else()
                        list(APPEND LIBXML2_LIBRARY_LIST -lpthread)
                    endif()
                endif()
            endforeach()
        else()
            find_path   (LIBXML2_INCLUDE_DIRS libxml/SAX2.h)
            find_library(LIBXML2_LIBRARY_LIST xml2)
        endif()
    else()
        if (PKG_CONFIG_LIBXML2_FOUND)
            find_path   (LIBXML2_INCLUDE_DIRS libxml/SAX2.h HINTS ${PKG_CONFIG_LIBXML2_INCLUDE_DIRS})
            find_library(LIBXML2_LIBRARY_LIST libxml2.a     HINTS ${PKG_CONFIG_LIBXML2_LIBRARY_DIRS})
        else()
            find_path   (LIBXML2_INCLUDE_DIRS libxml/SAX2.h)
            find_library(LIBXML2_LIBRARY_LIST xml2)
        endif()
    endif()

    if (PKG_CONFIG_LIBXML2_VERSION)
        set(LIBXML2_VERSION ${PKG_CONFIG_LIBXML2_VERSION})
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibXML2 REQUIRED_VARS LIBXML2_LIBRARY_LIST LIBXML2_INCLUDE_DIRS VERSION_VAR LIBXML2_VERSION)

mark_as_advanced(LIBXML2_INCLUDE_DIRS LIBXML2_LIBRARY_LIST)

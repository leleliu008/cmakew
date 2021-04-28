# try to find iconv.h API, once done this will define 
#
# ICONV_FOUND       - system has Iconv 
# ICONV_INCLUDE_DIR - the Iconv include directory 
# ICONV_LIBRARY     - the filepath of Iconv library
# ICONV_VERSION     - the version  of Iconv library


if (ICONV_INCLUDE_DIR AND ICONV_LIBRARY)
    set(ICONV_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_ICONV QUIET libiconv)

    #message("PKG_CONFIG_ICONV_FOUND=${PKG_CONFIG_ICONV_FOUND}")
    #message("PKG_CONFIG_ICONV_INCLUDE_DIRS=${PKG_CONFIG_ICONV_INCLUDE_DIRS}")
    #message("PKG_CONFIG_ICONV_LIBRARY_DIRS=${PKG_CONFIG_ICONV_LIBRARY_DIRS}")
    #message("PKG_CONFIG_ICONV_INCLUDEDIR=${PKG_CONFIG_ICONV_INCLUDEDIR}")
    #message("PKG_CONFIG_ICONV_LIBDIR=${PKG_CONFIG_ICONV_LIBDIR}")
    #message("PKG_CONFIG_ICONV_VERSION=${PKG_CONFIG_ICONV_VERSION}")
     
    if (ENABLE_STATIC)
        set(ICONV_LIBRARY_NAMES iconv libiconv.a c)
    else()
        set(ICONV_LIBRARY_NAMES iconv libiconv   c)
    endif()

    if (PKG_CONFIG_ICONV_FOUND)
        find_path(   ICONV_INCLUDE_DIR   iconv.h                HINTS ${PKG_CONFIG_ICONV_INCLUDE_DIRS})
        find_library(ICONV_LIBRARY NAMES ${ICONV_LIBRARY_NAMES} HINTS ${PKG_CONFIG_ICONV_LIBRARY_DIRS})
    else()
        find_path(   ICONV_INCLUDE_DIR       iconv.h)
        find_library(ICONV_LIBRARY     NAMES ${ICONV_LIBRARY_NAMES})
    endif()

    if (ICONV_INCLUDE_DIR AND ICONV_LIBRARY)
        if (PKG_CONFIG_ICONV_VERSION)
            set(ICONV_VERSION ${PKG_CONFIG_ICONV_VERSION})
        endif()

        set(CMAKE_REQUIRED_INCLUDES  ${ICONV_INCLUDE_DIR})
        set(CMAKE_REQUIRED_LIBRARIES ${ICONV_LIBRARY})

        include(CheckCSourceCompiles)
        
        check_c_source_compiles("
            #include <stddef.h>
            #include <iconv.h>
            int main() {
                char *a, *b;
                size_t i, j;
                iconv_t ic;
                ic = iconv_open(\"to\", \"from\");
                iconv(ic, &a, &i, &b, &j);
                iconv_close(ic);
            }
            " ICONV_IS_OK)

        set(CMAKE_REQUIRED_INCLUDES)
        set(CMAKE_REQUIRED_LIBRARIES)
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    Iconv
    FOUND_VAR ICONV_FOUND
    REQUIRED_VARS ICONV_LIBRARY ICONV_INCLUDE_DIR ICONV_IS_OK
    VERSION_VAR ICONV_VERSION
)

mark_as_advanced(ICONV_INCLUDE_DIR ICONV_LIBRARY)

# try to find icudata API, once done this will define 
#
# ICU_DATA_FOUND       - system has icudata 
# ICU_DATA_INCLUDE_DIR - the icudata include directory 
# ICU_DATA_LIBRARY     - the filepath of icudata library
# ICU_DATA_VERSION     - the version  of icudata library


if (ICU_DATA_INCLUDE_DIR AND ICU_DATA_LIBRARY)
    set(ICU_DATA_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_ICU_DATA QUIET icu-data)

    #message("PKG_CONFIG_ICU_DATA_FOUND=${PKG_CONFIG_ICU_DATA_FOUND}")
    #message("PKG_CONFIG_ICU_DATA_INCLUDE_DIRS=${PKG_CONFIG_ICU_DATA_INCLUDE_DIRS}")
    #message("PKG_CONFIG_ICU_DATA_LIBRARY_DIRS=${PKG_CONFIG_ICU_DATA_LIBRARY_DIRS}")
    #message("PKG_CONFIG_ICU_DATA_INCLUDEDIR=${PKG_CONFIG_ICU_DATA_INCLUDEDIR}")
    #message("PKG_CONFIG_ICU_DATA_LIBDIR=${PKG_CONFIG_ICU_DATA_LIBDIR}")
    #message("PKG_CONFIG_ICU_DATA_VERSION=${PKG_CONFIG_ICU_DATA_VERSION}")
    message("PKG_CONFIG_ICU_DATA_LIBRARIES=${PKG_CONFIG_ICU_DATA_LIBRARIES}")
    message("PKG_CONFIG_ICU_DATA_STATIC_LIBRARIES=${PKG_CONFIG_ICU_DATA_STATIC_LIBRARIES}")
     
    if (ENABLE_STATIC)
        set(ICU_DATA_LIBRARY_NAMES libicudata.a icudata)
    else()
        set(ICU_DATA_LIBRARY_NAMES icudata)
    endif()

    if (PKG_CONFIG_ICU_DATA_FOUND)
        find_path   (ICU_DATA_INCLUDE_DIR   unicode/idna.h            HINTS ${PKG_CONFIG_ICU_DATA_INCLUDE_DIRS})
        find_library(ICU_DATA_LIBRARY NAMES ${ICU_DATA_LIBRARY_NAMES} HINTS ${PKG_CONFIG_ICU_DATA_LIBRARY_DIRS})
    else()
        find_path   (ICU_DATA_INCLUDE_DIR   unicode/idna.h)
        find_library(ICU_DATA_LIBRARY NAMES ${ICU_DATA_LIBRARY_NAMES})
    endif()

    if (ICU_DATA_INCLUDE_DIR AND ICU_DATA_LIBRARY)
        if (PKG_CONFIG_ICU_DATA_VERSION)
            set(ICU_DATA_VERSION ${PKG_CONFIG_ICU_DATA_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    ICU_DATA
    FOUND_VAR ICU_DATA_FOUND
    REQUIRED_VARS ICU_DATA_LIBRARY ICU_DATA_INCLUDE_DIR
    VERSION_VAR ICU_DATA_VERSION
)

mark_as_advanced(ICU_DATA_INCLUDE_DIR ICU_DATA_LIBRARY)

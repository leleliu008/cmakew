# try to find icuuc API, once done this will define 
#
# ICU_UC_FOUND       - system has icuuc 
# ICU_UC_INCLUDE_DIR - the icuuc include directory 
# ICU_UC_LIBRARY     - the filepath of icuuc library
# ICU_UC_VERSION     - the version  of icuuc library


if (ICU_UC_INCLUDE_DIR AND ICU_UC_LIBRARY)
    set(ICU_UC_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_ICU_UC QUIET icu-uc)

    #message("PKG_CONFIG_ICU_UC_FOUND=${PKG_CONFIG_ICU_UC_FOUND}")
    #message("PKG_CONFIG_ICU_UC_INCLUDE_DIRS=${PKG_CONFIG_ICU_UC_INCLUDE_DIRS}")
    #message("PKG_CONFIG_ICU_UC_LIBRARY_DIRS=${PKG_CONFIG_ICU_UC_LIBRARY_DIRS}")
    #message("PKG_CONFIG_ICU_UC_INCLUDEDIR=${PKG_CONFIG_ICU_UC_INCLUDEDIR}")
    #message("PKG_CONFIG_ICU_UC_LIBDIR=${PKG_CONFIG_ICU_UC_LIBDIR}")
    #message("PKG_CONFIG_ICU_UC_VERSION=${PKG_CONFIG_ICU_UC_VERSION}")
    message("PKG_CONFIG_ICU_UC_LIBRARIES=${PKG_CONFIG_ICU_UC_LIBRARIES}")
    message("PKG_CONFIG_ICU_UC_STATIC_LIBRARIES=${PKG_CONFIG_ICU_UC_STATIC_LIBRARIES}")
     
    if (ENABLE_STATIC)
        set(ICU_UC_LIBRARY_NAMES libicuuc.a icuuc)
    else()
        set(ICU_UC_LIBRARY_NAMES icuuc)
    endif()

    if (PKG_CONFIG_ICU_UC_FOUND)
        find_path   (ICU_UC_INCLUDE_DIR   unicode/idna.h          HINTS ${PKG_CONFIG_ICU_UC_INCLUDE_DIRS})
        find_library(ICU_UC_LIBRARY NAMES ${ICU_UC_LIBRARY_NAMES} HINTS ${PKG_CONFIG_ICU_UC_LIBRARY_DIRS})
    else()
        find_path   (ICU_UC_INCLUDE_DIR   unicode/idna.h)
        find_library(ICU_UC_LIBRARY NAMES ${ICU_UC_LIBRARY_NAMES})
    endif()

    if (ICU_UC_INCLUDE_DIR AND ICU_UC_LIBRARY)
        if (PKG_CONFIG_ICU_UC_VERSION)
            set(ICU_UC_VERSION ${PKG_CONFIG_ICU_UC_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    ICU_UC
    FOUND_VAR ICU_UC_FOUND
    REQUIRED_VARS ICU_UC_LIBRARY ICU_UC_INCLUDE_DIR
    VERSION_VAR ICU_UC_VERSION
)

mark_as_advanced(ICU_UC_INCLUDE_DIR ICU_UC_LIBRARY)

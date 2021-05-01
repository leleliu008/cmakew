# try to find libicui18n, once done following variables will be defined
#
# ICU_I18N_FOUND       - system has libicui18n
# ICU_I18N_VERSION     - the version of libicui18n
# ICU_I18N_INCLUDE_DIR - the libicui18n include directory
# ICU_I18N_LIBRARY     - the filepath of libicui18n.a|so|dylib


if (ICU_I18N_INCLUDE_DIR AND ICU_I18N_LIBRARY)
    set(ICU_I18N_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_ICU_I18N QUIET icu-i18n)

    #message("PKG_CONFIG_ICU_I18N_FOUND=${PKG_CONFIG_ICU_I18N_FOUND}")
    #message("PKG_CONFIG_ICU_I18N_INCLUDE_DIRS=${PKG_CONFIG_ICU_I18N_INCLUDE_DIRS}")
    #message("PKG_CONFIG_ICU_I18N_LIBRARY_DIRS=${PKG_CONFIG_ICU_I18N_LIBRARY_DIRS}")
    #message("PKG_CONFIG_ICU_I18N_INCLUDEDIR=${PKG_CONFIG_ICU_I18N_INCLUDEDIR}")
    #message("PKG_CONFIG_ICU_I18N_LIBDIR=${PKG_CONFIG_ICU_I18N_LIBDIR}")
    #message("PKG_CONFIG_ICU_I18N_VERSION=${PKG_CONFIG_ICU_I18N_VERSION}")
    message("PKG_CONFIG_ICU_I18N_LIBRARIES=${PKG_CONFIG_ICU_I18N_LIBRARIES}")
    message("PKG_CONFIG_ICU_I18N_STATIC_LIBRARIES=${PKG_CONFIG_ICU_I18N_STATIC_LIBRARIES}")
     
    if (ENABLE_STATIC)
        set(ICU_I18N_LIBRARY_NAMES libicui18n.a icui18n)
    else()
        set(ICU_I18N_LIBRARY_NAMES icui18n)
    endif()

    if (PKG_CONFIG_ICU_I18N_FOUND)
        find_path   (ICU_I18N_INCLUDE_DIR   unicode/idna.h            HINTS ${PKG_CONFIG_ICU_I18N_INCLUDE_DIRS})
        find_library(ICU_I18N_LIBRARY NAMES ${ICU_I18N_LIBRARY_NAMES} HINTS ${PKG_CONFIG_ICU_I18N_LIBRARY_DIRS})
    else()
        find_path   (ICU_I18N_INCLUDE_DIR   unicode/idna.h)
        find_library(ICU_I18N_LIBRARY NAMES ${ICU_I18N_LIBRARY_NAMES})
    endif()

    if (ICU_I18N_INCLUDE_DIR AND ICU_I18N_LIBRARY)
        if (PKG_CONFIG_ICU_I18N_VERSION)
            set(ICU_I18N_VERSION ${PKG_CONFIG_ICU_I18N_VERSION})
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    ICU_I18N
    FOUND_VAR ICU_I18N_FOUND
    REQUIRED_VARS ICU_I18N_LIBRARY ICU_I18N_INCLUDE_DIR
    VERSION_VAR ICU_I18N_VERSION
)

mark_as_advanced(ICU_I18N_INCLUDE_DIR ICU_I18N_LIBRARY)

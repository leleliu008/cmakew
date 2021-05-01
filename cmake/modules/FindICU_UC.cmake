# try to find libicuuc, once done following variables will be defined
#
# ICU_UC_FOUND       - system has libicuuc
# ICU_UC_VERSION     - the version of libicuuc

# ICU_UC_INCLUDE_DIR - the libicuuc include directory
# ICU_UC_LIBRARY     - the filepath of libicuuc.a|so|dylib
#
# ICU_UC_INCLUDE_DIRS - the libicuuc include directory      and it's dependencies's include directory
# ICU_UC_LIBRARY_LIST - the filepath of libicuuc.a|so|dylib and it's dependencies's

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
     
    set(ICU_UC_INCLUDE_DIR)
    set(ICU_UC_LIBRARY)

    set(ICU_UC_INCLUDE_DIRS)
    set(ICU_UC_LIBRARY_LIST)

    if (ENABLE_STATIC)
        if (PKG_CONFIG_ICU_UC_FOUND)
            foreach(item ${PKG_CONFIG_ICU_UC_STATIC_LIBRARIES})
                if (item STREQUAL "icuuc")
                    find_path   (ICU_UC_INCLUDE_DIR   unicode/idna.h   HINTS ${PKG_CONFIG_ICU_UC_INCLUDE_DIRS})
                    find_library(ICU_UC_LIBRARY NAMES libicuuc.a icuuc HINTS ${PKG_CONFIG_ICU_UC_LIBRARY_DIRS})
                elseif (item STREQUAL "dl")
                    find_package(LIBDL)
                    if (LIBDL_FOUND)
                        list(APPEND ICU_UC_INCLUDE_DIRS ${LIBDL_INCLUDE_DIR})
                        list(APPEND ICU_UC_LIBRARY_LIST ${LIBDL_LIBRARY})
                    endif()
                elseif (item STREQUAL "m")
                    find_package(LIBM)
                    if (LIBM_FOUND)
                        list(APPEND ICU_UC_INCLUDE_DIRS ${LIBM_INCLUDE_DIR})
                        list(APPEND ICU_UC_LIBRARY_LIST ${LIBM_LIBRARY})
                    endif()
                endif()
            endforeach()
        else()
            find_path   (ICU_UC_INCLUDE_DIR   unicode/idna.h)
            find_library(ICU_UC_LIBRARY NAMES libicuuc.a icuuc)
        endif()
    else()
        if (PKG_CONFIG_ICU_UC_FOUND)
            find_path   (ICU_UC_INCLUDE_DIR   unicode/idna.h HINTS ${PKG_CONFIG_ICU_UC_INCLUDE_DIRS})
            find_library(ICU_UC_LIBRARY NAMES icuuc          HINTS ${PKG_CONFIG_ICU_UC_LIBRARY_DIRS})
        else()
            find_path   (ICU_UC_INCLUDE_DIR   unicode/idna.h)
            find_library(ICU_UC_LIBRARY NAMES icuuc)
        endif()
    endif()

    if (ICU_UC_INCLUDE_DIR AND ICU_UC_LIBRARY)
        list(INSERT ICU_UC_INCLUDE_DIRS 0 ${ICU_UC_INCLUDE_DIR})
        list(INSERT ICU_UC_LIBRARY_LIST 0 ${ICU_UC_LIBRARY})
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

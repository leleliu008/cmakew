# try to find seccomp.h and libseccomp, once done following variables will be defined
#
# LIBSECCOMP_FOUND       - system has libseccomp
# LIBSECCOMP_VERSION     - the version of libseccomp
# LIBSECCOMP_INCLUDE_DIR - the libseccomp include directory
# LIBSECCOMP_LIBRARY     - the filepath of libseccomp.a|so|dylib


if (LIBSECCOMP_INCLUDE_DIR AND LIBSECCOMP_LIBRARY)
    set(LIBSECCOMP_FOUND TRUE)
else()
    pkg_check_modules(PKG_CONFIG_LIBSECCOMP QUIET libseccomp)

    #message("PKG_CONFIG_LIBSECCOMP_FOUND=${PKG_CONFIG_LIBSECCOMP_FOUND}")
    #message("PKG_CONFIG_LIBSECCOMP_INCLUDE_DIRS=${PKG_CONFIG_LIBSECCOMP_INCLUDE_DIRS}")
    #message("PKG_CONFIG_LIBSECCOMP_LIBRARY_DIRS=${PKG_CONFIG_LIBSECCOMP_LIBRARY_DIRS}")
    #message("PKG_CONFIG_LIBSECCOMP_INCLUDEDIR=${PKG_CONFIG_LIBSECCOMP_INCLUDEDIR}")
    #message("PKG_CONFIG_LIBSECCOMP_LIBDIR=${PKG_CONFIG_LIBSECCOMP_LIBDIR}")
    #message("PKG_CONFIG_LIBSECCOMP_VERSION=${PKG_CONFIG_LIBSECCOMP_VERSION}")

    if (ENABLE_STATIC)
        set(LIBSECCOMP_LIBRARY_NAMES libseccomp.a)
    else()
        set(LIBSECCOMP_LIBRARY_NAMES seccomp)
    endif()

    if (PKG_CONFIG_LIBSECCOMP_FOUND)
        find_path(   LIBSECCOMP_INCLUDE_DIR seccomp.h                   HINTS ${PKG_CONFIG_LIBSECCOMP_INCLUDE_DIRS})
        find_library(LIBSECCOMP_LIBRARY     ${LIBSECCOMP_LIBRARY_NAMES} HINTS ${PKG_CONFIG_LIBSECCOMP_LIBRARY_DIRS})
    else()
        find_path(   LIBSECCOMP_INCLUDE_DIR seccomp.h)
        find_library(LIBSECCOMP_LIBRARY     ${LIBSECCOMP_LIBRARY_NAMES})
    endif()
    
    if (LIBSECCOMP_INCLUDE_DIR)
        if (PKG_CONFIG_LIBSECCOMP_VERSION)
            set(LIBSECCOMP_VERSION ${PKG_CONFIG_LIBSECCOMP_VERSION})
        else()
            file(READ "${LIBSECCOMP_INCLUDE_DIR}/seccomp.h" LIBSECCOMP_VERSION_CONTENT)
            
            string(REGEX MATCH "#define[ \t]+SCMP_VER_MAJOR[ \t]+([0-9]+)" _dummy "${LIBSECCOMP_VERSION_CONTENT}")
            set(LIBSECCOMP_VERSION_MAJOR "${CMAKE_MATCH_1}")

            string(REGEX MATCH "#define[ \t]+SCMP_VER_MINOR[ \t]+([0-9]+)" _dummy "${LIBSECCOMP_VERSION_CONTENT}")
            set(LIBSECCOMP_VERSION_MINOR "${CMAKE_MATCH_1}")

            string(REGEX MATCH "#define[ \t]+SCMP_VER_MICRO[ \t]+([0-9]+)" _dummy "${LIBSECCOMP_VERSION_CONTENT}")
            set(LIBSECCOMP_VERSION_MICRO "${CMAKE_MATCH_1}")

            set(LIBSECCOMP_VERSION "${LIBSECCOMP_VERSION_MAJOR}.${LIBSECCOMP_VERSION_MINOR}.${LIBSECCOMP_VERSION_MICRO}")
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LIBSECCOMP REQUIRED_VARS LIBSECCOMP_LIBRARY LIBSECCOMP_INCLUDE_DIR VERSION_VAR LIBSECCOMP_VERSION)

mark_as_advanced(LIBSECCOMP_INCLUDE_DIR LIBSECCOMP_LIBRARY)

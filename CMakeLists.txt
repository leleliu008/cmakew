cmake_minimum_required(VERSION 3.7)

project(universal-ctags C)

set(PACKAGE_NAME  ${PROJECT_NAME})
set(PACKAGE_VERSION 5.9.0)
set(PACKAGE_HOMEPAGE_URL "https://ctags.io")
set(PACKAGE_BUGREPORT_URL "https://github.com/universal-ctags/ctags/issues")

##########################################################################################

# {{{  define custom options
option(ENABLE_STATIC  "if link static libraries."  ON)

option(ENABLE_XML     "if support XML feature."  ON)
option(ENABLE_YAML    "if support YAML feature." ON)
option(ENABLE_JSON    "if support JSON feature." ON)

#option(ENABLE_LIBZ    "if use libz."        ON)
#option(ENABLE_LIBLZMA "if use liblzma."     ON)

option(ENABLE_ICONV   "if use iconv.h API." ON)
option(ENABLE_SECCOMP "if use libseccomp."  ON)
option(ENABLE_GCOV    "if use gcov."        ON)

option(USE_INTERNAL_SORT "if use internal sort, otherwise use external sort." ON)

option(BUILD_TESTING    "if build and run tests."    ON)
option(BUILD_MANPAGES   "if build and install docs." ON)

option(INSTALL_READTAGS "if build and install readtags binary." ON)
option(INSTALL_ETAGS    "if build and install etags binary."    ON)

# https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry
set(HOST_CC     cc CACHE STRING "C Compiler for build packcc." FORCE)
set(HOST_CFLAGS "" CACHE STRING "CFLAGS for HOST_CC." FORCE)
# }}}

##########################################################################################

# {{{  handle default values
# https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

if ((CMAKE_BUILD_TYPE STREQUAL Release) OR (CMAKE_BUILD_TYPE STREQUAL MinSizeRel))
    set(ENABLE_GCOV OFF)
endif()

if (ENABLE_GCOV)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fprofile-arcs -ftest-coverage")
endif()

if (NOT HOST_CC)
    set(HOST_CC cc)
endif()

if (USE_INTERNAL_SORT)
    set(INTERNAL_SORT 1)
else()
    set(EXTERNAL_SORT 1)
endif()

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/modules/" ${CMAKE_MODULE_PATH})
# }}}

##########################################################################################

# {{{ checking
include(cmake/modules/utils.cmake)

check_if_have_header_files(direct.h dirent.h fcntl.h fnmatch.h inttypes.h io.h memory.h stat.h stdbool.h stdint.h stdlib.h strings.h string.h sys/dir.h sys/stat.h sys/types.h sys/wait.h types.h unistd.h)

check_if_have_functions(regcomp asprintf snprintf _snprintf chmod chsize findfirst _findfirst findnext fnmatch truncate ftruncate mblen mkstemp opendir scandir setenv putenv strcasecmp strncasecmp stricmp strnicmp strerror strstr tempnam)

include(CheckSymbolExists)
check_symbol_exists(__environ     unistd.h      HAVE_DECL___ENVIRON)

# https://github.com/rizsotto/Bear/pull/290
check_symbol_exists(_NSGetEnviron crt_externs.h HAVE_DECL__NSGETENVIRON)
# }}}

##########################################################################################

# {{{ check prototypes if exists
# https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/string.h.html
include(CheckPrototypeDefinition)
check_prototype_definition(strnlen    "size_t strnlen(const char *s, size_t maxlen)" "0" string.h HAVE_DECL_STRNLEN)
check_prototype_definition(stat       "int stat(const char *restrict path, struct stat *restrict buf)" "0"  sys/stat.h HAVE_PROTO_STAT)
check_prototype_definition(lstat      "int lstat(const char *restrict path, struct stat *restrict buf)" "0" sys/stat.h HAVE_PROTO_LSTAT)
check_prototype_definition(truncate   "int truncate(const char *path, off_t length)" "0" unistd.h HAVE_PROTO_TRUNCATE)
check_prototype_definition(ftruncate  "int ftruncate(int fildes, off_t length)" "0"      unistd.h HAVE_PROTO_FTRUNCATE)

if (NOT HAVE_PROTO_STAT)
    set(NEED_PROTO_STAT 1)
endif()

if (NOT HAVE_PROTO_LSTAT)
    set(NEED_PROTO_LSTAT 1)
endif()

if (NOT HAVE_PROTO_TRUNCATE)
    set(NEED_PROTO_TRUNCATE 1)
endif()

if (NOT HAVE_PROTO_FTRUNCATE)
    set(NEED_PROTO_FTRUNCATE 1)
endif()
# }}}

##########################################################################################

string(TIMESTAMP COMPILED_DATETIME "%Y%m%d%H%M%S" UTC)

git_commit_id(GIT_COMMITID)

optlib2c()

mkdir(${PROJECT_BINARY_DIR})

build_packcc()

use_packcc_to_convert_peg_files_to_c_files()

##########################################################################################

# {{{ when the target system is Windows, including Win64.
if (WIN32)
    add_definitions(-DWIN32)
    include_directories(${PROJECT_SOURCE_DIR}/src)
    set(WIN32_SRCS win32/mkstemp/mkstemp.c win32/ctags.rc)
endif()
# }}}

##########################################################################################

# {{{ find libraries
include(FindPkgConfig)
if (NOT PKG_CONFIG_FOUND)
    message(FATAL_ERROR "pkgconfig is needed.")
endif()

#if (ENABLE_LIBZ)
#    find_package(LibZ)
#    if (LIBZ_FOUND)
#        set(HAVE_LIBZ 1)
#    endif()
#endif()
#
#if (ENABLE_LIBLZMA)
#    find_package(LibLZMA)
#    if (LIBLZMA_FOUND)
#        set(HAVE_LIBLZMA 1)
#    endif()
#endif()


if (ENABLE_XML)
    find_package(LibXML2)
    if (LIBXML2_FOUND)
        set(HAVE_LIBXML 1)
    endif()
endif()

if (ENABLE_YAML)
    find_package(LibYAML)
    if (LIBYAML_FOUND)
        set(HAVE_LIBYAML 1)
    endif()
endif()

if (ENABLE_JSON)
    find_package(Jansson)
    if (JANSSON_FOUND)
        set(HAVE_JANSSON 1)
    endif()
endif()

if (ENABLE_ICONV)
    find_package(Iconv)
    if (ICONV_FOUND)
        set(HAVE_ICONV 1)
    endif()
endif()

if (ENABLE_SECCOMP)
    find_package(LibSeccomp)
    if (LIBSECCOMP_FOUND)
        set(HAVE_SECCOMP 1)
    endif()
endif()
# }}}

##########################################################################################

# {{{ generate config.h
configure_file(cmake/config.h.in config.h @ONLY)
add_definitions(-DHAVE_CONFIG_H)
include_directories(${PROJECT_BINARY_DIR})
# }}}

##########################################################################################

if (HAVE_STRNLEN)
    add_definitions(-DUSE_SYSTEM_STRNLEN)
endif()

##########################################################################################

# {{{ build gnu_regex if needed
if (NOT HAVE_REGCOMP)
    add_library(gnu_regex STATIC gnu_regex/regex.c)
    target_include_directories(gnu_regex INTERFACE gnu_regex)
    target_compile_definitions(gnu_regex PRIVATE -D_GNU_SOURCE -D__USE_GNU)
endif()
# }}}

##########################################################################################

# {{{ build readtags if want
if (INSTALL_READTAGS)
    aux_source_directory(dsl DSL_SRCS)
    aux_source_directory(extra-cmds EXTRA_SRCS)

    add_executable(readtags libreadtags/readtags.c main/mio.c ${DSL_SRCS} ${EXTRA_SRCS})
    
    if (NOT HAVE_REGCOMP)
        target_link_libraries(readtags gnu_regex)
    endif()
    target_include_directories(readtags PRIVATE libreadtags)
    target_include_directories(readtags PRIVATE ${PROJECT_SOURCE_DIR})
    target_compile_definitions(readtags PRIVATE -DREADTAGS_DSL)
endif()
# }}}

##########################################################################################

# {{{ prepare source files
if (NOT HAVE_FNMATCH)
    include_directories(fnmatch)
    aux_source_directory(fnmatch FNMATCH_SRCS)
endif()

aux_source_directory(peg PEG_SRCS)
aux_source_directory(main CTAGS_SRCS)
aux_source_directory(optlib OPTLIB_SRCS)
aux_source_directory(parsers PARSERS_SRCS)
aux_source_directory(parsers/cxx PARSER_CXX_SRCS)

foreach(item cmd.c mini-geany.c)
    list(REMOVE_ITEM CTAGS_SRCS "main/${item}")
endforeach()

if (NOT HAVE_LIBXML)
    foreach(item maven2.c dbusintrospect.c glade.c svg.c plist.c relaxng.c xml.c xslt.c)
        list(REMOVE_ITEM PARSERS_SRCS "parsers/${item}")
    endforeach()
endif()

if (NOT HAVE_LIBYAML)
    foreach(item yaml.c ansibleplaybook.c)
        list(REMOVE_ITEM PARSERS_SRCS "parsers/${item}")
    endforeach()
endif()

include_directories(main)
# }}}

##########################################################################################

# {{{ build libctags ctags
add_library(libctags STATIC src/datetime/datetime.c ${CTAGS_SRCS} ${WIN32_SRCS} ${FNMATCH_SRCS} ${OPTLIB_SRCS} ${PARSERS_SRCS} ${PARSER_CXX_SRCS} ${PEG_SRCS})

target_include_directories(libctags PRIVATE src)
target_include_directories(libctags PRIVATE peg)
target_compile_definitions(libctags PRIVATE -DHAVE_PACKCC)

if (NOT HAVE_REGCOMP)
    target_include_directories(libctags PUBLIC  gnu_regex)
    target_link_libraries(     libctags         gnu_regex)
endif()

if (HAVE_LIBXML)
    target_include_directories(libctags PUBLIC  ${LIBXML2_INCLUDE_DIRS})
    target_link_libraries(     libctags         ${LIBXML2_LIBRARY_LIST})

    #if (HAVE_LIBZ)
    #    target_include_directories(libctags PUBLIC  ${LIBZ_INCLUDE_DIR})
    #    target_link_libraries(     libctags         ${LIBZ_LIBRARY})
    #endif()

    #if (HAVE_LIBLZMA)
    #    target_include_directories(libctags PUBLIC  ${LIBLZMA_INCLUDE_DIR})
    #    target_link_libraries(     libctags         ${LIBLZMA_LIBRARY})
    #endif()
endif()

if (HAVE_LIBYAML)
    target_include_directories(libctags PRIVATE ${LIBYAML_INCLUDE_DIR})
    target_link_libraries(     libctags         ${LIBYAML_LIBRARY})
endif()

if (HAVE_JANSSON)
    target_include_directories(libctags PRIVATE ${JANSSON_INCLUDE_DIR})
    target_link_libraries(     libctags         ${JANSSON_LIBRARY})
endif()

if (HAVE_ICONV)
    target_include_directories(libctags PRIVATE ${ICONV_INCLUDE_DIR})
    target_link_libraries(     libctags         ${ICONV_LIBRARY})
endif()

if (HAVE_SECCOMP)
    target_include_directories(libctags PRIVATE ${LIBSECCOMP_INCLUDE_DIR})
    target_link_libraries(     libctags         ${LIBSECCOMP_LIBRARY})
endif()

add_executable(ctags main/cmd.c)
target_link_libraries(ctags libctags)

add_executable(mini-geany main/mini-geany.c)
target_link_libraries(mini-geany libctags)
# }}}

##########################################################################################

# {{{ installation
include(GNUInstallDirs)

install(TARGETS ctags RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

if (INSTALL_ETAGS)
    install_link(ctags etags)
endif()

if (INSTALL_READTAGS)
    install(TARGETS readtags RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()

if (BUILD_MANPAGES)
    build_and_install_manpages()
endif()
# }}}

##########################################################################################}}}

# {{{ config for cpack
set(CPACK_PACKAGE_NAME ${PACKAGE_NAME})
set(CPACK_PACKAGE_VERSION ${PACKAGE_VERSION})
set(CPACK_PACKAGE_FILE_NAME ${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${COMPILED_DATETIME}-${CMAKE_SYSTEM_NAME})
set(CPACK_GENERATOR "ZIP;TGZ;TXZ")

set(CPACK_SOURCE_PACKAGE_FILE_NAME ${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${COMPILED_DATETIME})
set(CPACK_SOURCE_GENERATOR "ZIP;TGZ;TXZ")
set(CPACK_SOURCE_IGNORE_FILES
        ${PROJECT_SOURCE_DIR}/build.d
        ${PROJECT_SOURCE_DIR}/output
        ${PROJECT_SOURCE_DIR}/pack
        ${PROJECT_SOURCE_DIR}/.idea
        ${PROJECT_SOURCE_DIR}/.vscode
        ${PROJECT_SOURCE_DIR}/.git
        ${PROJECT_SOURCE_DIR}/.github
        ${PROJECT_SOURCE_DIR}/.gitignore
        ${PROJECT_SOURCE_DIR}/.DS_Store)

set(CPACK_PACKAGE_DIRECTORY ${PROJECT_SOURCE_DIR}/pack)

include(CPack)
# }}}

##########################################################################################}}}

# {{{ config for ctest
include(CTest)
if (BUILD_TESTING)
    find_program(PYTHON3_EXECUTABLE NAMES python3 python3.9 python3.8 python3.7 python3.6 python3.5 python)
    if (NOT PYTHON3_EXECUTABLE)
        message(FATAL_ERROR "Could NOT Found pyhton3.")
    endif()
    
    file(GLOB MANS "man/ctags-lang-*.7.rst.in")
    add_test(
        NAME man
        COMMAND ${PYTHON3_EXECUTABLE} ${PROJECT_SOURCE_DIR}/misc/man-test.py ${PROJECT_BINARY_DIR}/test/man ${PROJECT_BINARY_DIR}/ctags ${MANS}
    )
    
    if (INSTALL_READTAGS)
        add_test(
            NAME roundtrip
            COMMAND sh ${PROJECT_SOURCE_DIR}/misc/roundtrip ${PROJECT_BINARY_DIR}/readtags ${PROJECT_SOURCE_DIR}/Units
        )
    endif()

endif()
# }}}

#print_all_variables_and_names()


# set foldmethod=marker

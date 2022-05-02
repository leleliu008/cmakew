
# {{{ define function mkdir(DIR)
function(mkdir)
    message(STATUS "run : ${CMAKE_COMMAND} -E make_directory ${ARGV0}")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory ${ARGV0}
        RESULT_VARIABLE ERROR
    )
    if (ERROR)
        message(FATAL_ERROR "")
    endif()
    unset(ERROR)
endfunction()
# }}}

##########################################################################################

# {{{ define function install_link(SRC DEST)
function(install_link)
    if (UNIX)
        install(CODE "execute_process(COMMAND ln -sf ${ARGV0} ${ARGV1} WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR})")
    elseif (MSVC)
        # https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/mklink
        install(CODE "execute_process(COMMAND cmd /c mklink ${ARGV1}.exe ${ARGV0}.exe WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR})")
    endif()
endfunction()
# }}}

##########################################################################################


# {{{ define function print_all_variables_and_names()
function(print_all_variables_and_names)
    get_cmake_property(_variableNames VARIABLES)
    list (SORT _variableNames)
    foreach (_variableName ${_variableNames})
        message(STATUS "${_variableName}=${${_variableName}}")
    endforeach()
endfunction()
# }}}

##########################################################################################

# {{{ define function check_if_have_header_files(...)
function(check_if_have_header_files)
    include(CheckIncludeFiles)
    foreach(item ${ARGV})
        string(REPLACE "/" "_" item2 "${item}")
        string(REPLACE "." "_" item2 "${item2}")
        string(TOUPPER "${item2}" item2)
        check_include_files(${item} HAVE_${item2})
        #message("HAVE_${item2}=${HAVE_${item2}}")
    endforeach()
endfunction()
# }}}

##########################################################################################

# {{{ define function check_if_have_functions(...)
function(check_if_have_functions)
    include(CheckFunctionExists)
    foreach(item ${ARGV})
        string(TOUPPER ${item} item2)
        check_function_exists(${item} HAVE_${item2})
        #message("HAVE_${item2}=${HAVE_${item2}}")
    endforeach()
endfunction()
# }}}

##########################################################################################

# {{{ define function find_packages(...)
function(find_packages)
    foreach(item ${ARGV})
        find_package(${item})
        if (${item}_FOUND)
            set(HAVE_${item} 1)
        endif()
    endforeach()
endfunction()
# }}}

##########################################################################################

# {{{ define macro git_commit_id(OUTPUT_VARIABLE)
macro(git_commit_id)
    include(FindGit)
    find_package(Git)
    if (GIT_FOUND)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} log -1 --pretty=format:%h
            OUTPUT_VARIABLE ${ARGV0}
            OUTPUT_STRIP_TRAILING_WHITESPACE
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        )
    endif()
endmacro()
#}}}

##########################################################################################

# {{{ define function optlib2c()
function(optlib2c)
    include(FindPerl)
    if (PERL_FOUND)
        file(GLOB OPTLIB_CTAGS RELATIVE ${PROJECT_SOURCE_DIR}/optlib "optlib/*.ctags")
        foreach(item ${OPTLIB_CTAGS})
            string(REPLACE ".ctags" "" item2 ${item})
            message(STATUS "run : ${PERL_EXECUTABLE} ./misc/optlib2c optlib/${item} > optlib/${item2}.c")
            execute_process(
                COMMAND ${PERL_EXECUTABLE} ./misc/optlib2c optlib/${item}
                RESULT_VARIABLE ERROR
                OUTPUT_FILE optlib/${item2}.c
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            )
            if (ERROR)
                message(FATAL_ERROR "")
            endif()
            unset(ERROR)
        endforeach()
    endif()
endfunction()
# }}}

##########################################################################################

# {{{ define function build_packcc()
macro(build_packcc)
    if (MSVC)
        message(STATUS "run : ${CMAKE_COMMAND} -S ${PROJECT_SOURCE_DIR}/misc/packcc -B ${PROJECT_BINARY_DIR}/packcc")
        execute_process(
            COMMAND ${CMAKE_COMMAND} -S ${PROJECT_SOURCE_DIR}/misc/packcc -B ${PROJECT_BINARY_DIR}/packcc
            RESULT_VARIABLE ERROR
        )
        if (ERROR)
            message(FATAL_ERROR "")
        else()
            unset(ERROR)
        endif()

        message(STATUS "run : ${CMAKE_COMMAND} --build ${PROJECT_BINARY_DIR}/packcc")
        execute_process(
            COMMAND ${CMAKE_COMMAND} --build ${PROJECT_BINARY_DIR}/packcc
            RESULT_VARIABLE ERROR
        )
        if (ERROR)
            message(FATAL_ERROR "")
        else()
            unset(ERROR)
        endif()

        set(PACKCC_COMMAND ${PROJECT_BINARY_DIR}/packcc/Debug/packcc.exe)
    else()
        set(PACKCC_COMMAND ${PROJECT_BINARY_DIR}/packcc)

        message(STATUS "run : ${HOST_CC} ${HOST_CFLAGS} -o ${PACKCC_COMMAND} ${PROJECT_SOURCE_DIR}/misc/packcc/src/packcc.c")
        execute_process(
            COMMAND ${HOST_CC} ${HOST_CFLAGS} -o ${PACKCC_COMMAND} ${PROJECT_SOURCE_DIR}/misc/packcc/src/packcc.c
            RESULT_VARIABLE ERROR
        )
        if (ERROR)
            message(FATAL_ERROR "")
        else()
            unset(ERROR)
        endif()
    endif()
endmacro()
# }}}

##########################################################################################

# {{{ define function use_packcc_to_convert_peg_files_to_c_files()
function(use_packcc_to_convert_peg_files_to_c_files)
    file(GLOB PEGS RELATIVE ${PROJECT_SOURCE_DIR}/peg "peg/*.peg")
    foreach(item ${PEGS})
        string(REPLACE ".peg" "" item2 ${item})
        message(STATUS "run : ${PACKCC_COMMAND} -o ${item2} ${item}")
        execute_process(
            COMMAND ${PACKCC_COMMAND} -o ${item2} ${item}
            RESULT_VARIABLE ERROR
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/peg
        )
        if (ERROR)
            message(FATAL_ERROR "")
        endif()
        unset(ERROR)
    endforeach()
endfunction()
#}}}

##########################################################################################

# {{{ define function build_and_install_manpages()
function(build_and_install_manpages)
    find_program(PYTHON3_EXECUTABLE NAMES python3 python3.9 python3.8 python3.7 python3.6 python3.5 python)
    if (PYTHON3_EXECUTABLE)
        find_program(RST2MAN_EXECUTABLE NAMES rst2man rst2man.py rst2man-3 rst2man-3.6 rst2man-3.7 rst2man-3.8 rst2man-3.9)
        if (RST2MAN_EXECUTABLE)

            mkdir(${PROJECT_BINARY_DIR}/man)

            set(VERSION ${PROJECT_VERSION})
            set(CTAGS_NAME_EXECUTABLE ctags)
            set(ETAGS_NAME_EXECUTABLE etags)

            file(GLOB RSTS RELATIVE ${PROJECT_SOURCE_DIR} "man/*.rst.in")
            foreach(item ${RSTS})
                string(REPLACE ".rst.in" "" item2 ${item})

                configure_file(${item} ${PROJECT_BINARY_DIR}/${item2}.rst @ONLY)

                message(STATUS "run : ${RST2MAN_EXECUTABLE} ${PROJECT_BINARY_DIR}/${item2}.rst")
                execute_process(
                    COMMAND ${RST2MAN_EXECUTABLE} ${PROJECT_BINARY_DIR}/${item2}.rst
                    RESULT_VARIABLE ERROR
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    OUTPUT_FILE ${PROJECT_BINARY_DIR}/${item2}
                )
                if (ERROR)
                    message(FATAL_ERROR "${RST2MAN_EXECUTABLE} ${PROJECT_BINARY_DIR}/${item2}.rst failed.")
                endif()
                unset(ERROR)
                unset(item)
                unset(item2)
            endforeach()

            foreach(item 1 5 7)
                file(GLOB MAN${item}S "${PROJECT_BINARY_DIR}/man/*.${item}")
                install(FILES ${MAN${item}S} DESTINATION ${CMAKE_INSTALL_MANDIR}/man${item})
            endforeach()
        else()
            message(WARNING "rst2man command can't found.")
        endif()
    else()
        message(WARNING "Python3 can't found.")
    endif()
endfunction()
# }}}

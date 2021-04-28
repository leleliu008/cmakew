cmake_minimum_required(VERSION 3.0)

project(packcc C)

include(CheckFunctionExists)

check_function_exists(strnlen HAVE_FN_STRNLEN)

if (HAVE_FN_STRNLEN)
    add_definitions(-DUSE_SYSTEM_STRNLEN)
endif()

add_executable(packcc src/packcc.c)

include(GNUInstallDirs)

install(TARGETS packcc RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

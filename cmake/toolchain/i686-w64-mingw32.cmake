set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_VERSION 10.0)

set(CMAKE_C_COMPILER   i686-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER i686-w64-mingw32-g++)
set(CMAKE_RC_COMPILER  i686-w64-mingw32-windres)
set(CMAKE_AR           i686-w64-mingw32-ar)
set(CMAKE_RANLIB       i686-w64-mingw32-ranlib)
set(CMAKE_NM           i686-w64-mingw32-nm)
set(CMAKE_STRIP        i686-w64-mingw32-strip)

set(CMAKE_FIND_ROOT_PATH ${PROJECT_SOURCE_DIR}/thirdparty)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

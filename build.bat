if ""%1""=="""" (set VS_VERSION=2019) else (set VS_VERSION=%1)

"C:\Program Files (x86)\Microsoft Visual Studio\%VS_VERSION%\BuildTools\Common7\Tools\VsDevCmd.bat"

cmake ^
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^
    -DCMAKE_VERBOSE_MAKEFILE=ON ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%cd%/output ^
    -Wno-dev ^
    -S . ^
    -B build.d &
cmake --build build.d --target install

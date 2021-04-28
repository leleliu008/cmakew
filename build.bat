cmake ^
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^
    -DCMAKE_VERBOSE_MAKEFILE=ON ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%cd%/output ^
    -Wno-dev ^
    -S . ^
    -B build.d &
cmake --build build.d --target install

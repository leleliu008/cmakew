cd $(dirname "$0") || exit 1

unset CFLAGS
unset CPPFLAGS
unset LDFLAGS

./cmakew config \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=./output/mingw \
    -DCMAKE_TOOLCHAIN_FILE=./cmake/toolchain/x86_64-w64-mingw32.cmake \
    -Wno-dev \
    -S . \
    -B build.d/mingw &&
./cmakew build &&
./cmakew install

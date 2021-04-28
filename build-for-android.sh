#!/bin/sh

[ -z "$ANDROID_NDK_HOME" ] && {
    echo "ANDROID_NDK_HOME environment variable is not exported."
    exit 1
}

unset CFLAGS
unset CPPFLAGS
unset LDFLAGS

for ABI in armeabi-v7a arm64-v8a x86 x86_64
do
    ./cmakew config \
        -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake" \
        -DANDROID_TOOLCHAIN=clang \
        -DANDROID_ABI=$ABI \
        -DANDROID_ARM_NEON=TRUE \
        -DANDROID_PLATFORM=21 \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=./output/android/$ABI \
        -Wno-dev \
        -S . \
        -B build.d/android/$ABI &&
    ./cmakew build &&
    ./cmakew install
done

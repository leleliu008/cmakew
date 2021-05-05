# CMake Build System

## requirements
|software&nbsp;&nbsp;&nbsp;|required?|purpose|note|
|-|-|-|-|
|[cmake](https://cmake.org/)|required|for generating low-level build system config file||
|[pkg-config](https://www.freedesktop.org/wiki/Software/pkg-config/)|required|for finding libraries||
|[python](https://www.python.org/)|recommended|for providing a runtime for `docutils`|if can't found, manpages will not be installed.|
|[docutils](https://docutils.sourceforge.io/)|recommended|for generating manpages|if can't found, manpages will not be installed.|
|[perl](https://www.perl.org/)|recommended|for converting peg files to c files.|if can't found, just using pre-converted c files.|

|library|required?|purpose|note|
|-|-|-|-|
|[libiconv](http://www.gnu.org/software/libiconv/)|recommended|text coding convert support.|this library have been already included in some platform.|
|[libxml2](http://xmlsoft.org/)|recommended|XML support||
|[libyaml](https://github.com/yaml/libyaml/)|recommended|YAML support||
|[jansson](https://github.com/akheron/jansson)|recommended|JSON support||
|[libseccomp](https://github.com/seccomp/libseccomp/)|recommended|sandbox support|available on GNU/Linux|

## cmake options
|option|type|default|purpose|
|-|-|-|-|
|HOST_CC|STRING|cc|C Compiler to build `packcc`.|
|HOST_CFLAGS|STRING||`CFLAGS` for `HOST_CC`.|
|||||
|ENABLE_STATIC|BOOL|OFF|if static library preferred.|
|||||
|ENABLE_XML|BOOL|ON|if support `XML` feature.|
|ENABLE_YAML|BOOL|ON|if support `YAML` feature.|
|ENABLE_JSON|BOOL|ON|if support `JSON` feature.|
|||||
|USE_ICONV|BOOL|ON|if use [iconv.h](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/iconv.h.html) API.|
|USE_LIBSECCOMP|BOOL|ON|if use `libseccomp`.|
|USE_INTERNAL_SORT|BOOL|ON|if use internal `sort`, otherwise use external `sort`.|
|USE_GCOV|BOOL|ON|if use `gcov`.|
|||||
|BUILD_MANPAGES|BOOL|ON|if build and install manpages.|
|BUILD_TESTING|BOOL|OFF|if config for ctest.|
|||||
|INSTALL_READTAGS|BOOL|ON|if install `readtags` command.|
|INSTALL_ETAGS|BOOL|ON|if install `etags` link.|
||||||

## build for current machine (WINDOWS)

**step1. install [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/)**

```
choco install -y visualstudio2019buildtools
choco install -y visualstudio2019-workload-vctools
choco install -y pkgconfiglite
```

**step2. start "Visual Studio Developer Command Prompt"**

```
"C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\VsDevCmd.bat"
```

**step3. config**
```
cmake ^
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^
    -DCMAKE_VERBOSE_MAKEFILE=ON ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%cd%/output ^
    -Wno-dev ^
    -S . ^
    -B build.d
```
**step4. build**
```
cmake --build build.d
```
**step5. install**
```
cmake --install build.d
```
**Note:** step4 and step5 can merge to 1 step
```
cmake --build build.d --target install
```

## build for current machine (UNIX)
**step1. install [GCC](https://gcc.gnu.org/) or [LLVM/Clang](https://llvm.org/) and other requirements**

**step2. open a terminal**

**step3. config**
```
cmake \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=`pwd`/output \
    -Wno-dev \
    -S . \
    -B build.d
```
**step4. build**
```
cmake --build build.d
```
**step5. install**
```
cmake --install build.d
```
**Note:** step4 and step5 can merge to 1 step
```
cmake --build build.d --target install
```

## cross-build for mingw
**step1. install [mingw-w64](http://mingw-w64.org) and other requirements**

**step2. open a terminal**

**step3. config**
```
unset CFLAGS
unset CPPFLAGS
unset LDFLAGS

cmake \
    -DCMAKE_TOOLCHAIN_FILE=./cmake/toolchain/x86_64-w64-mingw32.cmake \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=`pwd`/output \
    -Wno-dev \
    -S . \
    -B build.d
```
**step4. build**
```
cmake --build build.d
```
**step5. install**
```
cmake --install build.d
```
**Note:** step4 and step5 can merge to 1 step
```
cmake --build build.d --target install
```

## cross-build for Android
**step1. install [Android-NDK](https://developer.android.com/ndk/) and other requirements**

**step2. open a terminal**

**step3. run following code**

```
export ANDROID_NDK_HOME=/usr/local/opt/android-sdk/ndk-bundle

unset CFLAGS
unset CPPFLAGS
unset LDFLAGS

for ABI in armeabi-v7a arm64-v8a x86 x86_64
do
    cmake \
        -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake" \
        -DANDROID_TOOLCHAIN=clang \
        -DANDROID_ABI=$ABI \
        -DANDROID_ARM_NEON=TRUE \
        -DANDROID_PLATFORM=21 \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=`pwd`/output/android/$ABI \
        -Wno-dev \
        -S . \
        -B build.d/android/$ABI &&
    cmake --build build.d/android/$ABI --target install
done
```
**Note:** if you want to build for android easily, please try [ndk-pkg](https://github.com/leleliu008/ndk-pkg)

## packing
**pack source package**
```
cpack --config build.d/CPackSourceConfig.cmake
```
**pack binary package**
```
cpack --config build.d/CPackConfig.cmake
```
generated packages located in `pack` dir.

## cmake versions
|os-name|os-version|package-manager|cmake-version|works|
|-|-|-|-|-|
|[Debian GNU/Linux](https://www.debian.org/releases/)|8.11|[apt-get](https://manpages.debian.org/buster/apt/apt-get.8.en.html)|3.0.2|✗|
|[Debian GNU/Linux](https://www.debian.org/releases/)|9.13|[apt-get](https://manpages.debian.org/buster/apt/apt-get.8.en.html)|3.7.2|✔︎|
|[Debian GNU/Linux](https://www.debian.org/releases/)|10.7|[apt-get](https://manpages.debian.org/buster/apt/apt-get.8.en.html)|3.13.4|✔︎|
||||||
|[Ubuntu](https://releases.ubuntu.com/)|16.04|[apt-get](http://manpages.ubuntu.com/manpages/cosmic/man8/apt-get.8.html)|3.5.1|✗|
|[Ubuntu](https://releases.ubuntu.com/)|18.04|[apt-get](http://manpages.ubuntu.com/manpages/cosmic/man8/apt-get.8.html)|3.10.2|✔︎|
|[Ubuntu](https://releases.ubuntu.com/)|20.04|[apt-get](http://manpages.ubuntu.com/manpages/cosmic/man8/apt-get.8.html)|3.16.3|✔︎|
||||||
|[Linux Mint](https://linuxmint.com/)|19.3|[apt-get](https://community.linuxmint.com/tutorial/view/588)|3.10.2|✔︎|
|[Linux Mint](https://linuxmint.com/)|20.1|[apt-get](https://community.linuxmint.com/tutorial/view/588)|3.16.3|✔︎|
||||||
|[CentOS](https://www.centos.org/centos-linux/)|6.10|[yum](http://yum.baseurl.org/)|2.8.12.2|✗|
|[CentOS](https://www.centos.org/centos-linux/)|7.5.1804|[yum](http://yum.baseurl.org/)|2.8.12.2|✗|
|[CentOS](https://www.centos.org/centos-linux/)|8.3.2011|[dnf](https://github.com/rpm-software-management/dnf)|3.11.4|✔︎|
||||||
|[Fedora](https://getfedora.org/)|28|[dnf](https://github.com/rpm-software-management/dnf)|3.14.4|✔︎|
|[Fedora](https://getfedora.org/)|30|[dnf](https://github.com/rpm-software-management/dnf)|3.17.2|✔︎|
|[Fedora](https://getfedora.org/)|33|[dnf](https://github.com/rpm-software-management/dnf)|3.19.7|✔︎|
|[Fedora](https://getfedora.org/)|rawhide|[dnf](https://github.com/rpm-software-management/dnf)|3.19.7|✔︎|
||||||
|[openSUSE Leap](https://get.opensuse.org/leap)|15.1|[zypper](https://en.opensuse.org/Portal:Zypper)|3.10.2|✔︎|
|[openSUSE Leap](https://get.opensuse.org/leap)|15.2|[zypper](https://en.opensuse.org/Portal:Zypper)|3.17.0|✔︎|
||||||
|[Alpline Linux](https://alpinelinux.org/)|3.9.3|[apk](https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html)|3.13.0|✔︎|
|[Alpline Linux](https://alpinelinux.org/)|3.10.9|[apk](https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html)|3.14.5|✔︎|
|[Alpline Linux](https://alpinelinux.org/)|3.11.11|[apk](https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html)|3.15.5|✔︎|
|[Alpline Linux](https://alpinelinux.org/)|3.12.7|[apk](https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html)|3.17.2|✔︎|
|[Alpline Linux](https://alpinelinux.org/)|3.13.5|[apk](https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html)|3.18.4|✔︎|
||||||
|[VoidLinux-glibc](https://voidlinux.org/)|rolling|[xbps](https://github.com/void-linux/xbps/)|3.19.7|✔︎|
|[VoidLinux-musl](https://voidlinux.org/)|rolling|[xbps](https://github.com/void-linux/xbps/)|3.19.7|✔︎|
||||||
|[ArchLinux](https://archlinux.org/)|rolling|[pacman](https://wiki.archlinux.org/index.php/pacman)|3.20.1|✔︎|
||||||
|[Manjaro Linux](https://manjaro.org/)|rolling|[pacman](https://wiki.manjaro.org/index.php?title=Pacman_Overview)|3.19.4|✔︎|
||||||
|[Gentoo Linux](https://www.gentoo.org/)|rolling|[Portage](https://wiki.gentoo.org/wiki/Portage)|3.14.6|✔︎|
||||||
|[FreeBSD](https://www.freebsd.org/)|11.4|[pkg](https://github.com/freebsd/pkg)|3.19.6|✔︎|
|[FreeBSD](https://www.freebsd.org/)|12.2|[pkg](https://github.com/freebsd/pkg)|3.19.2|✔︎|
||||||
|[OpenBSD](https://www.openbsd.org/)|6.8|[pkg_*](https://www.openbsdhandbook.com/package_management/)|3.17.2|✔︎|
||||||
|[NetBSD](https://www.netbsd.org/)|8.2|[pkgin](https://pkgin.net/)|3.18.2|✔︎|
|[NetBSD](https://www.netbsd.org/)|9.1|[pkgin](https://pkgin.net/)|3.19.2|✔︎|
||||||
|[macOS](https://www.apple.com/macos)|11.2.3|[HomeBrew](https://brew.sh/)|latest|✔︎|
||||||
|[Windows](https://www.microsoft.com/en-us/windows)|10|[Chocolatey](https://chocolatey.org/)|latest|✔︎|
|[Cygwin](https://www.cygwin.com/)||[Chocolatey](https://chocolatey.org/)|latest|✔︎|
|[MSYS2](https://www.msys2.org/)||[pacman](https://www.msys2.org/docs/package-management/)|latest|✔︎|

## cmakew
some old version of system's package manager install very old version of cmake. I encourage user to use `cmakew` but using `cmake` directly.

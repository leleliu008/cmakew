# cmakew
`cmakew` is a `POSIX` shell script which is desinged to help you using cmake easily.

## how to use
```bash
cd /path/to/your cmake project
curl -LO https://raw.githubusercontent.com/leleliu008/cmakew/master/cmakew
chmod +x cmakew
./cmakew
```

## cmakew command usage
*   print the help infomation of `cmakew` command

        ./cmakew -h
        ./cmakew --help

*   print the version of `cmakew`

        ./cmakew -V
        ./cmakew --version

*   generate config

        ./cmakew [ -x | -d | --rc-file=FILE ] config [ -DCMAKE_INSTALL_PREFIX=/usr | -DCMAKE_BUILD_TYPE=Release | ... ]

*   clean the cached config

        ./cmakew [ -x | -d | --rc-file=FILE ] clean

*   build

        ./cmakew [ -x | -d | --rc-file=FILE ] build

*   install

        ./cmakew [ -x | -d | --rc-file=FILE ] install

*   pack

        ./cmakew [ -x | -d | --rc-file=FILE ] pack

*   run tests

        ./cmakew [ -x | -d | --rc-file=FILE ] test


## cmakew.rc
`cmakew.rc` is also a `POSIX` shell script. It is a extension of `cmakew`. It will be automatically loaded if it exists. you can specify a different one via `--rc-file=FILE`.

a typical example of this file looks like as follows:

```bash
perform_config_pre() {
    required command cc:gcc:clang
    required command pkg-config ge 0.18
    required command perl
    required command python3:python:python3.5:python3.6:python3.7:python3.8:python3.9 ge 3.5
    optional command rst2man:rst2man.py:rst2man-3:rst2man-3.6:rst2man-3.7:rst2man-3.8:rst2man-3.9
}

perform_XX() {
    # do whatever you want."
}
```

`perform_xxxx` is declared a subcommand of `cmakew` called `xxxx`, we can invoke it via run following command:

```
./cmakew    xxxx
./cmakew -x xxxx
./cmakew -d xxxx
```

### the function can be declared in `autogen.rc`
|function|overview|
|-|-|
|`perform_XX(){}`|declared subcommand of `cmakew`, invoke it via run `./camkew XX`|
|`perform_XX_pre(){}`|`XX = config/build/install/clean/pack/test`<br>run before `perform_XX(){}`|
|`perform_XX_post(){}`|`XX = config/build/install/clean/pack/test`<br>run after `perform_XX(){}`|

### the function can be invoked in `perform_XX_pre`
|function|overview|
|-|-|
|`required TYPE NAME [OP VERSION]`|declare required `command` / `perl` / `python` modules.|
|`optional TYPE NAME [OP VERSION]`|declare optional `command` / `perl` / `python` modules.|

### the function can be invoked in `cmakew.rc`
|function|example|
|-|-|
|`print`|`print 'your message.'`|
|`echo`|`echo 'your message.'`|
|`info`|`info 'your infomation.'`|
|`warn`|`warn "warnning message."`|
|`error`|`error 'error message.'`|
|`die`|`die "please specify a package name."`|
|`success`|`success "build success."`|
|`sed_in_place`|`sed_in_place 's/xx/yy/g' config.h`|

### the variable can be used in `cmakew.rc`
|variable|overview|
|-|-|
|`DEBUG`|`[ "$DEBUG" = 'true' ] && echo xx`|
|||
|`NATIVE_OS_TYPE`|current machine os type.|
|`NATIVE_OS_NAME`|current machine os name.|
|`NATIVE_OS_VERS`|current machine os version.|
|`NATIVE_OS_ARCH`|current machine os arch.|
|||
|`PROJECT_DIR`|the project dir.|
|`PROJECT_NAME`|the project name.|
|`PROJECT_VERSION`|the project version.|
|||
|`CMAKE_VERSION_MREQUIRED`|min required version of cmake.|

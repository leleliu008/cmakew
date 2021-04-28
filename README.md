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

        ./cmakew config [ -x | -d ]

*   clean the cached config

        ./cmakew clean [ -x | -d ]

*   build

        ./cmakew build [ -x | -d ]

*   install

        ./cmakew install [ -x | -d ]

*   pack

        ./cmakew pack [ -x | -d ]

*   run tests

        ./cmakew test [ -x | -d ]


## cmakew.rc
`cmakew.rc` is also a `POSIX` shell script. It is a extension of `cmakew`. It will be automatically loaded if it exists.

a typical example of this file looks like as follows:

```bash

perform_xxxx() {
    # do whatever you want."
}

perform_yyyy() {
    # do whatever you want."
}
```
run command
```
./cmakew xxxx
./cmakew yyyy
```

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
|`sed_in_place`|`sed_in_place 's/-mandroid//g' Configure`|

### the variable can be used in `cmakew.rc`
|variable|overview|
|-|-|
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

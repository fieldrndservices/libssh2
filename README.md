# LabSSH2-C - A LabVIEW-friendly fork of the libssh2 C library

LabSSH2-C is a fork of the [libssh2](https://www.libssh2.org) project that includes modifications to support interfacing with the [LabVIEW&trade;](http://www.ni.com/labview) graphical programming language developed and distributed by [National Instruments](http://www.ni.com). 

[![GitHub release](https://img.shields.io/github/release/fieldrndservices/labssh2-c.svg)](https://github.com/fieldrndservices/labssh2-c/releases)
[![license](https://img.shields.io/github/license/fieldrndservices/labssh2-c.svg)](https://github.com/fieldrndservices/labssh2-c/blob/master/LICENSE)

## History

LabVIEW provides the ability to interface with shared libraries (.dll, .so, and .dylib) that implement a C ABI through the [Call Library Function](http://zone.ni.com/reference/en-XX/help/371361P-01/glang/call_library_function/) node. However, the `Call Library Function` node is relatively limited, specifically when it comes to strings and pointers. The limitation that affects using the `libssh2` library without modification is lack of support for passing a `NULL` value as a parameter and function pointers, i.e. callbacks. The problem is that the `libssh2` has a number of `*_ex` functions in its public API that can take `NULL` to indicate using a built-in or default configuration. There are a number of convenience macro functions that wrap the various `*_ex` functions and pass `NULL` as needed. It would be possible to just use the convenience functions, but macro functions are not included shared libraries, as these are defined in header files and evaluated during compile-time. Thus, this library converts the macro functions to "real" functions to avoid the `NULL` argument limitation with LabVIEW's `Call Library Function` node.

Note, the build output of this project/fork is renamed from `libssh2` to `labssh2` to avoid overwritten or name collision with existing installations of `libssh2` on many platforms and to indicate the output is related to usage with LabVIEW. Field R&D Services does _not_ claim any ownership, copyright, or trademark over the [libssh2](http://www.libssh2.org) project and its properties.

## Build

Ensure all of the following dependencies are installed before proceeding:

- [CMake 3.10.x](https://cmake.org/), or newer
- [Microsoft Visual C++ Build Tools 2017](https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2017), Windows Only
- [XCode Command Line Tools](https://developer.apple.com/xcode/features/), macOS Only
- [Git](https://git-scm.com/)
- [C/C++ Development Tools for NI Linux Real-Time, Eclipse Edition 2017](http://www.ni.com/download/labview-real-time-module-2017/6731/en/), NI Linux RT only
- [OpenSSL v1.1.0g](http://www.openssl.org), static libraries only
- [ActivePerl](https://www.activestate.com/activeperl), Only if building the OpenSSL static Windows libraries

### OpenSSL

Regardless of platform, the [OpenSSL v1.1.0g](http://www.openssl.org) library is needed. The `labssh2` shared library is statically linked with the OpenSSL static libraries, `libcrypto` and `libssl`, to minimize dependencies during distribution for LabVIEW developers. This means that static libraries for OpenSSL must be present on the machine/platform/environment used to build the `labssh2` library.

**Note**, if the OpenSSL shared libraries are present, then the labssh2/libssh2 [Cmake](https://cmake.org) build system will be dynamically link instead of statically link to OpenSSL. The `OPENSSL_USE_STATIC_LIBS` option of the [FindOpenSSL](https://cmake.org/cmake/help/latest/module/FindOpenSSL.html) cmake module does not appear to work on Windows. This means that the OpenSSL shared libraries become a dependency and need to be present on the deployed system/machine/environment prior to using the labssh2 shared library; however, this does result in a smaller labssh2 shared library. The build dependencies for OpenSSL are the same as this project except Perl is needed instead of Cmake. On Windows, use the following commands to build and install OpenSSL in a way that works with statically linking with this project for 32-bit and 64-bit versions, respectively:

```dos
> perl Configure VC-WIN32 no-asm no-shared no-stdio
> nmake
> nmake install
```

```
> perl Configure VC-WIN64A no-asm no-shared no-stdio
> nmake
> nmake install
```

The `no-asm` avoids having to install an assembler. The `no-shared` option disables building the OpenSSL into shared/dynamic libraries and ensures OpenSSL is statically linked with this project. The `no-stdio` skips building the tests and application, which can increase the build time considerably and are ultimately unnecessary.

The `nmake install` command will "install" the static libraries into `C:\Program Files (x86)\OpenSSL` and `C:\Program Files\OpenSSL`, respectively. This step/command can be skipped to avoid overwriting an existing OpenSSL installation, which may be a different version and/or include the shared libraries, but then the `-DOPENSSL_ROOT_DIR=` option used during the [Windows build](#windows) of this project will have to be adjusted accordingly.

### Windows

The [Microsoft Visual C++ Build Tools 2017](https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2017) should have installed the `x86 Native Build Tools` and the `x64 Native Build Tools` command prompts. Use the `x86` command prompt for building the 32-bit versions of the DLL, and the `x64` command prompt for building the 64-bit version of the DLL. This ensures the appropriate C compiler is available to CMake to build the library. Run the following commands to obtain the source code:

```dos
> git clone https://github.com/fieldrndservices/labssh2-c.git LabSSH2-C
> cd LabSSH2-C
```

Then, running the following commands based on building a 32-bit or 64-bit version of the DLL. The `-DBUILD_TESTING=OFF` skips building the tests, which need the older `libeay` and `ssleay` shared/dynamic libraries. The shared library will still be built, but using the `-DBUILD_TESTING=OFF` eliminates a bunch of link errors during building.

#### 32-bit

```dos
> cmake -G"Visual Studio 15 2017" -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DCRYPTO_BACKEND=OpenSSL -DOPENSSL_ROOT_DIR="C:\Program Files (x86)\OpenSSL" ..
> cmake --build . --config Release
> cd src
> cd Release
> ren libssh2.dll labssh2.dll
```

#### 64-bit

```dos
> cmake -G"Visual Studio 15 2017 Win64" -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DCRYPTO_BACKEND=OpenSSL -DOPENSSL_ROOT_DIR="C:\Program Files (x86)\OpenSSL" ..
> cmake --build . --config Release
> cd src
> cd Release
> ren libssh2.ddl labssh2-x64.dll
```

## License

The labssh2 project is licensed under the [MIT](https://opensource.org/licenses/MIT). See the [LICENSE](https://github.com/fieldrndservices/labssh2-c/blob/master/LICENSE) and [COPYING](https://github.com/fieldrndservices/labssh2-c/blob/master/COPYING) file for more information about licensing and copyright. This project includes software developed by the OpenSSL Project for use in the OpenSSL Toolkit (http://www.openssl.org).


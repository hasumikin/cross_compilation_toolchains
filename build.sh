#!/bin/bash
# build.sh

set -e

BINUTILS_VERSION=binutils-2.34
GCC_VERSION=gcc-9.3.0
GDB_VERSION=gdb-9.1
NEWLIB_VERSION=newlib-3.1.0

INSTALL_PATH=$HOME/cross_compile_tools

build() {
  local TARGET="$1"

  # binutils
  cd $BINUTILS_VERSION
  ./configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap
  make all install
  cd -

  # gcc(1回目)
  cd $GCC_VERSION
  ./configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap --disable-libssp --enable-languages=c,c++ --with-newlib
  make all-gcc install-gcc
  cd -

  # newlib
  cd newlib-cygwin
  git chckout
  ./configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-bootstrap --disable-newlib-supplied-syscalls --enable-newlib-reent-small --disable-newlib-fvwrite-in-streamio --disable-newlib-fseek-optimization --disable-newlib-wide-orient --enable-newlib-nano-malloc --disable-newlib-unbuf-stream-opt --enable-lite-exit --enable-newlib-global-atexit --enable-newlib-nano-formatted-io --enable-target-optspace  --disable-nls
  make all install
  cd -

  # gcc(2回目)
  cd $GCC_VERSION
  ./configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap --disable-libssp --enable-languages=c,c++ --with-newlib --disable-libstdcxx-pch
  make all install
  cd -

  # gdb
  cd $GDB_VERSION
  ./configure --target=$TARGET --prefix=$HOME/$TARGET
  make all install
  cd -
}

build arm-none-eabi

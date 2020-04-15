#!/bin/bash
# build.sh

set -e

source ./vars.sh

INSTALL_PATH=$HOME/cross_compile_tools

build() {
  local TARGET="$1"

  # binutils
  cd src/$BINUTILS_VERSION
  ./configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap
  make -j4
  make install
  cd -

  # gcc(1回目)
  mkdir -p src/$GCC_VERSION/$TARGET
  cd src/$GCC_VERSION/$TARGET
  ../configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap --disable-libssp --enable-languages=c,c++ --with-newlib
  make -j4 all-gcc
  make install-gcc
  cd -

  # newlib
  mkdir -p $NEWLIB_VERSION/$TARGET
  cd $NEWLIB_VERSION/$TARGET
  ../configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-bootstrap --disable-newlib-supplied-syscalls --enable-newlib-reent-small --disable-newlib-fvwrite-in-streamio --disable-newlib-fseek-optimization --disable-newlib-wide-orient --enable-newlib-nano-malloc --disable-newlib-unbuf-stream-opt --enable-lite-exit --enable-newlib-global-atexit --enable-newlib-nano-formatted-io --enable-target-optspace  --disable-nls
  make -j4
  make install
  cd ../../..

  # src/gcc(2回目)
  mkdir -p src/$GCC_VERSION/$TARGET
  cd src/$GCC_VERSION/$TARGET
  ../configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap --disable-libssp --enable-languages=c,c++ --with-newlib --disable-libstdcxx-pch
  make -j4
  make install
  cd -

  # src/gdb
  mkdir -p src/$GDB_VERSION/$TARGET
  cd src/$GDB_VERSION/$TARGET
  ../configure --target=$TARGET --prefix=$HOME/$TARGET
  make -j4
  make install
  cd -
}

build arm-none-eabi

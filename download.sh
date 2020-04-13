#!/bin/bash
# download.sh

set -e

BINUTILS_VERSION=binutils-2.34
GCC_VERSION=gcc-9.3.0
GDB_VERSION=gdb-9.1
NEWLIB_VERSION=newlib-3.3.0

mkdir -p src
cd src

#wget -nc http://ftp.jaist.ac.jp/pub/GNU/binutils/${BINUTILS_VERSION}.tar.gz
#wget -nc http://ftpmirror.gnu.org/gcc/${GCC_VERSION}/${GCC_VERSION}.tar.gz
wget -nc http://ftpmirror.gnu.org/gdb/${GDB_VERSION}.tar.gz

for f in *.tar*; do
  tar xzf $f
done

#git clone git://sourceware.org/git/newlib-cygwin.git
cd newlib-cygwin
git checkout $NEWLIB_VERSION

cd -

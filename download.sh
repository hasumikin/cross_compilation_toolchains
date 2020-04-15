#!/bin/bash
# download.sh

set -e

source ./vars.sh

mkdir -p src
cd src

wget -nc http://ftp.jaist.ac.jp/pub/GNU/gmp/${GMP_VERSION}.tar.xz
wget -nc http://ftp.jaist.ac.jp/pub/GNU/mpfr/${MPFR_VERSION}.tar.xz
wget -nc http://ftp.jaist.ac.jp/pub/GNU/mpc/${MPC_VERSION}.tar.gz
wget -nc http://ftp.jaist.ac.jp/pub/GNU/binutils/${BINUTILS_VERSION}.tar.gz
wget -nc http://ftpmirror.gnu.org/gcc/${GCC_VERSION}/${GCC_VERSION}.tar.gz
wget -nc http://ftpmirror.gnu.org/gdb/${GDB_VERSION}.tar.gz
wget -nc ftp://sourceware.org/pub/newlib/${NEWLIB_VERSION}.tar.gz

for f in *.tar.xz; do
  xz -dc $f | tar xvf -
done

for f in *.tar.gz; do
  tar xzf $f
done

ln -s ${GMP_VERSION} ${GCC_VERSION}/gmp
ln -s ${MPFR_VERSION} ${GCC_VERSION}/mpfr
ln -s ${MPC_VERSION} ${GCC_VERSION}/mpc

cd -

#!/bin/bash
# download.sh

set -e

source ./vars.sh

mkdir -p src
cd src

rm -rf ${GMP_VERSION}
rm -rf ${MPFR_VERSION}
rm -rf ${MPC_VERSION}
rm -rf ${BINUTILS_VERSION}
rm -rf ${GCC_VERSION}
rm -rf ${GDB_VERSION}
rm -rf ${NEWLIB_VERSION}

wget -nc http://ftp.gnu.org/gnu/gmp/${GMP_VERSION}.tar.xz
wget -nc http://ftp.gnu.org/gnu/mpfr/${MPFR_VERSION}.tar.gz
wget -nc http://ftp.gnu.org/gnu/mpc/${MPC_VERSION}.tar.gz
wget -nc http://ftp.gnu.org/gnu/binutils/${BINUTILS_VERSION}.tar.gz
wget -nc http://ftp.gnu.org/gnu/gcc/${GCC_VERSION}/${GCC_VERSION}.tar.gz
wget -nc http://ftp.gnu.org/gnu/gdb/${GDB_VERSION}.tar.gz
wget -nc ftp://sourceware.org/pub/newlib/${NEWLIB_VERSION}.tar.gz

for f in *.tar.xz; do
  xzcat $f | tar -vxvf -
done

for f in *.tar.gz; do
  tar -vxzf $f
done

cd ${GCC_VERSION}
ln -s ../${GMP_VERSION} ./gmp
ln -s ../${MPFR_VERSION} ./mpfr
ln -s ../${MPC_VERSION} ./mpc

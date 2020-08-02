FROM ruby:2.7.1

RUN apt-get update -qq && apt-get install -y texinfo

ENV BINUTILS_VERSION  binutils-2.35
ENV GMP_VERSION       gmp-6.2.0
ENV MPFR_VERSION      mpfr-4.1.0
ENV MPC_VERSION       mpc-1.1.0
ENV GCC_VERSION       gcc-10.2.0
ENV GDB_VERSION       gdb-9.2
ENV NEWLIB_VERSION    newlib-3.3.0

ENV TARGET        arm-none-eabi
ENV INSTALL_PATH  /usr/local/bin

WORKDIR /src

# binutils
RUN curl -L http://ftp.gnu.org/gnu/binutils/${BINUTILS_VERSION}.tar.gz \
    | tar -vxzf - \
    && cd $BINUTILS_VERSION \
    && ./configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap \
    && make -j4 \
    && make install

# gcc (for building newlib)
RUN curl -L http://ftp.gnu.org/gnu/gmp/${GMP_VERSION}.tar.xz \
    | xzcat \
    | tar -vxvf -
RUN curl -L http://ftp.gnu.org/gnu/mpfr/${MPFR_VERSION}.tar.gz \
    | tar -vxzf -
RUN curl -L http://ftp.gnu.org/gnu/mpc/${MPC_VERSION}.tar.gz \
    | tar -vxzf -
RUN curl -L http://ftp.gnu.org/gnu/gcc/${GCC_VERSION}/${GCC_VERSION}.tar.gz \
    | tar -vxzf -
RUN cd $GCC_VERSION \
    && ln -s ../$GMP_VERSION ./gmp \
    && ln -s ../$MPFR_VERSION ./mpfr \
    && ln -s ../$MPC_VERSION ./mpc \
    && mkdir $TARGET \
    && cd $TARGET \
    && ../configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap --disable-libssp --enable-languages=c \
    && make -j4 all-gcc \
    && make install-gcc

# add arm-none-eabi-gcc to PATH to build newlib
ENV PATH $INSTALL_PATH/$TARGET/bin:$PATH

# newlib
RUN curl -L ftp://sourceware.org/pub/newlib/${NEWLIB_VERSION}.tar.gz \
    | tar -vxzf -
RUN cd $NEWLIB_VERSION \
    && mkdir $TARGET \
    && cd $TARGET \
    && ../configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-bootstrap --disable-newlib-supplied-syscalls --enable-newlib-reent-small --disable-newlib-fvwrite-in-streamio --disable-newlib-fseek-optimization --disable-newlib-wide-orient --enable-newlib-nano-malloc --disable-newlib-unbuf-stream-opt --enable-lite-exit --enable-newlib-global-atexit --enable-newlib-nano-formatted-io --enable-target-optspace  --disable-nls \
    && make -j4 \
    && make install

# gcc (final version with newlib)
RUN mkdir -p $GCC_VERSION/$TARGET \
    && cd $GCC_VERSION/$TARGET \
    && ../configure --target=$TARGET --prefix=$INSTALL_PATH/$TARGET --disable-werror --disable-nls --disable-bootstrap --disable-libssp --enable-languages=c,c++ --with-newlib --disable-libstdcxx-pchi \
    && make -j4 \
    && make install

# gdb
RUN curl -L http://ftp.gnu.org/gnu/gdb/${GDB_VERSION}.tar.gz \
    | tar -vxzf -
RUN mkdir -p $GDB_VERSION/$TARGET \
    && cd $GDB_VERSION/$TARGET \
    && ../configure --target=$TARGET --prefix=$HOME/$TARGET \
    && make -j4 \
    && make install \
    && ln -s /src/$GDB_VERSION/$TARGET/gdb/gdb $INSTALL_PATH/$TARGET/bin/gdb \
    && ln -s /src/$GDB_VERSION/$TARGET/gdb/gdb $INSTALL_PATH/$TARGET/bin/${TARGET}-gdb

WORKDIR /root

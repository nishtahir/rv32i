FROM ubuntu:latest

RUN apt-get update && apt-get -y install \
  binutils build-essential libtool texinfo \
  gzip zip unzip patchutils curl git \
  make cmake ninja-build automake bison flex gperf \
  grep sed gawk python3 python-is-python3 bc \
  zlib1g-dev libexpat1-dev libmpc-dev \
  libglib2.0-dev libfdt-dev libpixman-1-dev \
  bsdmainutils

WORKDIR /riscv
RUN mkdir _install
RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
RUN cd riscv-gnu-toolchain && ./configure --prefix=`pwd`/../_install --enable-multilib && make -j`nproc`
ENV PATH="/riscv/_install/bin:${PATH}"

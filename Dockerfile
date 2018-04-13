FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget curl bsdmainutils automake
ADD . /root/zcash
WORKDIR /root/zcash
RUN ./zcutil/fetch-params.sh
RUN /bin/bash -c './zcutil/build.sh -j$(nproc)'

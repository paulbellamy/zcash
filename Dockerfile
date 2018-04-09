FROM debian:stretch-slim

RUN apt-get update && apt-get install -y \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget curl bsdmainutils automake
ADD . /root/zcash
WORKDIR /root/zcash
RUN ./zcutil/fetch-params.sh
RUN /bin/bash -c './zcutil/build.sh -j$(nproc)'

LABEL zcash_version="1.0.12"
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends apt-transport-https gnupg ca-certificates wget && \
  wget -qO - https://apt.z.cash/zcash.asc | apt-key add - && \
  echo "deb https://apt.z.cash/ jessie main" | tee /etc/apt/sources.list.d/zcash.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends zcash && \
  apt-get purge -y apt-transport-https && \
  apt-get autoclean && \
  mkdir -p /root/.zcash-params /root/.zcash
COPY root /root
VOLUME ["/root"]
ENTRYPOINT ["/usr/bin/zcashd", "-printtoconsole"]

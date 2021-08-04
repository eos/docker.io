FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && apt-get install -y apt-transport-https software-properties-common curl gnupg
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get -qq update \
 && apt-get install -y autoconf automake g++ clang-6.0 libtool pkg-config \
    libboost-filesystem-dev libboost-python-dev libboost-system-dev libgsl0-dev libyaml-cpp-dev \
    python3 python3-dev python3-pip python3-h5py python3-matplotlib python3-scipy python3-yaml \
    git texlive-latex-base texlive-latex-extra texlive-xetex
RUN pip3 install sphinx sphinx-rtd-theme

# install g++-10
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get -qq update && apt install -y g++-10 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 80

# install pypmc
RUN pip3 install -U cython numpy scipy wilson
RUN pip3 install pypmc --no-binary pypmc

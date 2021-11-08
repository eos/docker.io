FROM ubuntu:hirsute
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get install -y autoconf automake g++ libtool pkg-config libboost-filesystem-dev \
    libboost-python-dev libboost-system-dev libgsl0-dev libyaml-cpp-dev \
    python3 python3-dev python3-pip python3-h5py python3-matplotlib python3-scipy python3-yaml \
    python3-sphinx python3-sphinx-rtd-theme \
    make git texlive-latex-base texlive-latex-extra texlive-xetex
RUN pip3 install -U cython numpy scipy wilson
RUN pip3 install pypmc --no-binary pypmc

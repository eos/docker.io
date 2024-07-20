FROM gitpod/workspace-full:2022-12-02-22-15-49

ENV DEBIAN_FRONTEND noninteractive
RUN sudo apt-get -qq update
RUN sudo apt-get install -y autoconf automake g++ clang-12 libtool pkg-config libboost-filesystem-dev \
    libboost-python-dev libboost-system-dev libgsl0-dev libyaml-cpp-dev \
    pandoc python3 python3-dev python3-pip python3-venv python3-h5py python3-matplotlib python3-numpy python3-scipy \
    make git texlive-latex-base texlive-latex-extra texlive-xetex cm-super dvipng

# install pypmc
RUN pip3 install --user -U argcomplete cython dynesty numpy pypmc termcolor scipy wilson

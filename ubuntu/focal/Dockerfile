FROM ubuntu:focal
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get install -y autoconf automake g++ clang-12 libtool pkg-config \
    libboost-filesystem-dev libboost-python-dev libboost-system-dev libgsl0-dev libyaml-cpp-dev \
    python3 python3-dev python3-pip python3-venv python3-h5py python3-matplotlib python3-numpy python3-scipy \
    make git texlive-latex-base texlive-latex-extra texlive-xetex cm-super dvipng

# install g++-10
RUN apt-get -qq update && apt install -y g++-10 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 80

# setup python virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# install python packages
#  upgrade pip first
RUN pip3 install --upgrade \
    pip wheel
#  install and upgrade user packages next
RUN pip3 install --upgrade \
    cython h5py jupyter matplotlib nbconvert numpy pypmc pyyaml scipy wilson

# install package cloud client
RUN apt-get install -y ruby-dev \
 && gem install rake package_cloud

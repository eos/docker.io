FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && apt-get install -y apt-transport-https software-properties-common curl gnupg
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get -qq update \
 && apt-get install -y autoconf automake g++ clang-6.0 libtool pkg-config \
    libboost-filesystem-dev libboost-python-dev libboost-system-dev libgsl0-dev libyaml-cpp-dev \
    python3 python3-dev python3-pip python3-venv python3-h5py python3-matplotlib python3-numpy python3-scipy \
    git texlive-latex-base texlive-latex-extra texlive-xetex cm-super dvipng

# install g++-10
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
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
    cython h5py jinja2 jupyter matplotlib nbconvert numpy pypmc pyyaml scipy sphinx sphinx-argparse sphinxcontrib-contentui sphinx-rtd-theme wilson

# install package cloud client
RUN apt-get install -y ruby-dev \
 && gem install rake package_cloud
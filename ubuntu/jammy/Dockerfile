FROM ubuntu:jammy
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get install -y autoconf automake g++ clang-14 libtool pkg-config libboost-filesystem-dev \
    libboost-python-dev libboost-system-dev libgsl0-dev libyaml-cpp-dev \
    pandoc python3 python3-dev python3-pip python3-venv python3-h5py python3-matplotlib python3-numpy python3-scipy \
    make git texlive-latex-base texlive-latex-extra texlive-xetex cm-super dvipng

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
    cython 'dynesty==2.0.3' h5py ipython ipykernel jinja2 jupyter matplotlib nbconvert networkx numpy pandoc pyhf pypmc pyyaml scipy \
    sphinx sphinx-argparse sphinxcontrib-contentui sphinx-rtd-theme nbsphinx wilson

# install package cloud client
RUN apt-get install -y ruby-dev \
 && gem install rake package_cloud
FROM ubuntu:jammy
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get install -y --no-install-recommends \
    gcc libboost-filesystem1.74 libboost-python1.74 libboost-system1.74 libgsl27 libyaml-cpp0.7 \
    python3 python3-pip python3-venv \
    git texlive-latex-base texlive-latex-extra texlive-xetex cm-super dvipng

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
    cython dynesty ipython ipykernel jupyter matplotlib nbconvert networkx numpy pypmc pyyaml scipy \
    wilson

RUN pip3 install --upgrade --pre eoshep
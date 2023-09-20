FROM ubuntu:jammy
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get install -y --no-install-recommends \
    python3 python3-pip tree \
    git texlive-latex-base texlive-xetex cm-super dvipng

# install python packages
#  upgrade pip first
RUN pip3 install --upgrade \
    pip wheel
#  install and upgrade user packages next
RUN pip3 install --upgrade \
    cython 'dynesty==2.0.3' ipython ipykernel jupyter matplotlib nbconvert networkx numpy 'pypmc>=1.2.2' pyyaml scipy \
    wilson \
	numpy pyhf pandas cabinetry matplotlib uproot pyunfold
RUN pip3 install --upgrade --pre 'eoshep>=1.0.9.dev1344'

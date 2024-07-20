FROM amd64/ubuntu:jammy
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get install -y --no-install-recommends \
    python3 python3-pip tree \
    git openssh-client texlive-latex-base texlive-xetex cm-super dvipng

# setup analysis user
RUN useradd -ms /bin/bash analysis \
 && mkdir -p /home/analysis \
 && mkdir -p /analysis \
 && chown -R analysis:analysis /home/analysis /analysis

# switch user
USER analysis

# install python packages
RUN pip3 install --user --upgrade \
    argcomplete cython ipython ipykernel jupyter matplotlib nbconvert networkx numpy 'pypmc>=1.2.2' pyyaml scipy \
    termcolor wilson \
	numpy pyhf pandas cabinetry matplotlib uproot pyunfold
RUN pip3 install --user --upgrade 'eoshep>=1.0.10'

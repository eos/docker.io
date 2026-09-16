FROM amd64/ubuntu:resolute-20260912
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update
RUN apt-get install -y python3 python3-venv \
    texlive-latex-base \
    texlive-latex-extra cm-super dvipng

# switch to ubuntu user and setup python virtual environment
USER ubuntu
ENV VIRTUAL_ENV=/home/ubuntu/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# install / upgrade pip and wheel
RUN pip3 install --upgrade pip wheel

# Pull base image.
FROM ubuntu:16.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get clean &&\
  apt-get update -y -qq && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# last cuda version, to change - LASTEST_CONDA
ENV LATEST_CONDA "5.0.1"
ENV PATH="/opt/anaconda/anaconda3/bin:${PATH}"

# download and install conda
RUN curl --silent -O https://repo.continuum.io/archive/Anaconda3-$LATEST_CONDA-Linux-x86_64.sh \
    && bash Anaconda3-$LATEST_CONDA-Linux-x86_64.sh -b -p /opt/anaconda/anaconda3

RUN add-apt-repository -y ppa:webupd8team/tor-browser && \
    apt-get update && \
    apt-get install -y tor-browser tor nano

ADD ./torrc /etc/tor

RUN pip install fake_useragent stem

COPY jupyter_notebook_config.py /root/.jupyter/

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["jupyter-notebook"]

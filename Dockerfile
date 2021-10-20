### 1. Get Linux
FROM ubuntu:18.04

ARG ROBOT=1.8.1
ARG JENA=3.17.0
ARG BGR=1.6.4
ARG CTD=0.1
ARG NCIT=0.6

### 2. Get Java, Python and all required system libraries
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    software-properties-common \
    build-essential \
    openjdk-8-jdk \
    git \
    make \
    curl \
    tar \
    python2.7 \
    python2.7-dev \
    python-pip \
    locales \
    && locale-gen "en_US.UTF-8"

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

### 3. Install custom tools
WORKDIR /tools

### Python packages ###
RUN pip2 install virtualenv &&\
    virtualenv -p python2.7 pyenv &&\
    . pyenv/bin/activate &&\
    pip2 install 'pandas==0.19.1' &&\
    pip2 install 'scipy==0.15.1' &&\
    pip2 install 'patsy==0.4.1' &&\
    pip2 install 'statsmodels==0.6.1'
ENV VIRTUAL_ENV /tools/pyenv
ENV PATH "$VIRTUAL_ENV/bin:$PATH"

###### JENA ######
RUN curl -O -L http://archive.apache.org/dist/jena/binaries/apache-jena-$JENA.tar.gz \
    && tar -zxf apache-jena-$JENA.tar.gz
ENV PATH "/tools/apache-jena-$JENA/bin:$PATH"

###### ROBOT ######
RUN curl -O -L https://github.com/ontodev/robot/releases/download/v$ROBOT/robot.jar \
    && curl -O -L https://github.com/ontodev/robot/raw/v$ROBOT/bin/robot \
    && chmod +x robot
ENV PATH "/tools:$PATH"

###### BLAZEGRAPH-RUNNER ######
RUN curl -O -L https://github.com/balhoff/blazegraph-runner/releases/download/v$BGR/blazegraph-runner-$BGR.tgz \
    && tar -zxf blazegraph-runner-$BGR.tgz \
    && chmod +x /tools/blazegraph-runner-$BGR
ENV PATH "/tools/blazegraph-runner-$BGR/bin:$PATH"

###### NCIT-UTILS ######
RUN curl -O -L https://github.com/NCI-Thesaurus/ncit-utils/releases/download/v$NCIT/ncit-utils-$NCIT.tgz \
    && tar -zxf ncit-utils-$NCIT.tgz \
    && chmod +x /tools/ncit-utils-$NCIT
ENV PATH "/tools/ncit-utils-$NCIT:$PATH"

###### CTD-TO-OWL ######
RUN curl -O -L https://github.com/balhoff/ctd-to-owl/releases/download/v$CTD/ctd-to-owl-$CTD.tgz \
    && tar -zxf ctd-to-owl-$CTD.tgz \
    && chmod +x /tools/ctd-to-owl-$CTD
ENV PATH "/tools/ctd-to-owl-$CTD/bin:$PATH"

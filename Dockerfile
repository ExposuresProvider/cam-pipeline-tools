### 1. Get Linux
FROM monarchinitiative/ubergraph:1.1

ARG ROBOT=1.8.1
ARG JENA=3.17.0
ARG BGR=1.6.5
ARG CTD=0.2.1
ARG MAT=0.1

### 2. Get Java and all required system libraries

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    openjdk-11-jdk-headless \
    git \
    make \
    curl \
    tar \
    screen \
    rsync \
    locales \
    && locale-gen "en_US.UTF-8"


### 3. Install custom tools
WORKDIR /tools

###### JENA ######
RUN curl -O -L http://archive.apache.org/dist/jena/binaries/apache-jena-$JENA.tar.gz \
    && tar -zxf apache-jena-$JENA.tar.gz
ENV PATH "/tools/apache-jena-$JENA/bin:$PATH"

###### BLAZEGRAPH-RUNNER ######
RUN curl -O -L https://github.com/balhoff/blazegraph-runner/releases/download/v$BGR/blazegraph-runner-$BGR.tgz \
    && tar -zxf blazegraph-runner-$BGR.tgz \
    && chmod +x /tools/blazegraph-runner-$BGR
ENV PATH "/tools/blazegraph-runner-$BGR/bin:$PATH"

###### MATERIALIZER ######
RUN curl -O -L https://github.com/balhoff/materializer/releases/download/v$MAT/materializer-$MAT.tgz \
    && tar -zxf materializer-$MAT.tgz \
    && chmod +x /tools/materializer-$MAT
ENV PATH "/tools/materializer-$MAT/bin:$PATH"

###### CTD-TO-OWL ######
RUN curl -O -L https://github.com/balhoff/ctd-to-owl/releases/download/v$CTD/ctd-to-owl-$CTD.tgz \
    && tar -zxf ctd-to-owl-$CTD.tgz \
    && chmod +x /tools/ctd-to-owl-$CTD
ENV PATH "/tools/ctd-to-owl-$CTD/bin:$PATH"

## Set USER to nru
RUN useradd -M -u 1000 nru
USER nru

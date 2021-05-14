FROM ubuntu:20.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y install \
            software-properties-common npm && \
    npm install -g yarn waffle && \
    rm -rf /var/lib/apt/lists/*

COPY . /opt
WORKDIR /opt
RUN yarn
RUN yarn compile
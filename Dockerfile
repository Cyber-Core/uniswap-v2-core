FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl software-properties-common git npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn waffle
RUN rm -rf /var/lib/apt/lists/*

COPY . /opt
WORKDIR /opt

RUN yarn && yarn compile

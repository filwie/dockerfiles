FROM ubuntu:bionic

ARG packages="sudo"

ENV TERM xterm-256color
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y --no-install-recommends install ${packages}

ADD . /repo
WORKDIR /repo

RUN ./setup.sh

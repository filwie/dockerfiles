FROM ubuntu:bionic

ARG packages="zsh vim tmux ncurses-bin git"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y --no-install-recommends install ${packages}

CMD ["/usr/bin/env", "zsh"]


FROM archlinux/base

ARG packages="zsh tmux vim ncurses git"

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen

RUN pacman -Sy --needed --noconfirm ${packages} > /dev/null

CMD ["/usr/bin/env", "zsh"]

FROM ubuntu:latest
LABEL maintainer="Sam Poulin <pamsoulin@gmail.com>"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    sudo \
    curl \
    neovim \
    tmux
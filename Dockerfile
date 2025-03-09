FROM ubuntu:latest
LABEL maintainer="Sam Poulin <pamsoulin@gmail.com>"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    sudo \
    curl \
    neovim \
    tmux \
    locales 

#configure utf-8 encoding
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

#create dev user
RUN sudo useradd -m -d /home/dev dev
USER dev

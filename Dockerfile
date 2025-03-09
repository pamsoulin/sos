FROM ubuntu:latest
LABEL maintainer="Sam Poulin <pamsoulin@gmail.com>"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    sudo \
    curl \
    neovim \
    tmux \
    locales 

### configure utf-8 encoding
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

### create dev user
RUN sudo useradd -m -d /home/dev dev -s /bin/bash
RUN echo dev:pswd | sudo chpasswd
# add user to sudo group and disable password on sudo
RUN usermod -aG sudo dev
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# create file to remove first-time sudo message for dev user
RUN touch home/dev/.sudo_as_admin_successful
# switch to dev user
USER dev
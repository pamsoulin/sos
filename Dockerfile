# syntax=docker/dockerfile:1

FROM archlinux/archlinux:latest

LABEL maintainer="Sam Poulin <pamsoulin@gmail.com>"

COPY scripts/ scripts/

SHELL ["/bin/bash", "-c"]

RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm \
    sudo \
    less \
    curl \
    git \
    github-cli \
    zsh \
    neovim \
    tmux \
    fastfetch
RUN pacman -Scc --noconfirm

### configure utf-8 encoding
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

### configure dev user
# create user
RUN sudo useradd -m -d /home/dev dev -s /bin/zsh
# set dev user password
RUN echo dev:pswd | sudo chpasswd
# add dev user to wheel group
RUN usermod -aG wheel dev
# add wheel group to sudoers
RUN sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
# remove password from sudo
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# switch to dev user
USER dev
# create file to remove first-time sudo message for dev user
RUN touch home/dev/.sudo_as_admin_successful
# copy any config files into dev user's home directory
COPY devhome/ home/dev/
# change ownership of all files in home/dev to the dev user
RUN sudo chown -R dev:dev home/dev

# configure zsh
ENV TERM=xterm-256color
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
RUN echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# configure git
RUN git config --global --add safe.directory "*"

# install uv
RUN sudo curl -LsSf https://astral.sh/uv/install.sh | sh 
ENV PATH="~/.local/bin/:$PATH"
RUN uv python install

WORKDIR /home/dev/work 
CMD ["/bin/zsh", "/scripts/startup.sh"]

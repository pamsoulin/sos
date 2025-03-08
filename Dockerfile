FROM ubuntu:latest
LABEL maintainer="Sam Poulin <pamsoulin@gmail.com>"

RUN apt-get install sudo -y

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y
FROM jokeswar/base-ctl

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yqq && apt-get install -yqq gcc-multilib nasm bc qemu-user

COPY ./checker ${CHECKER_DATA_DIRECTORY}

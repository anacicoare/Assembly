FROM jokeswar/base-ctl

RUN apt-get update -yqq && apt-get install -yqq gcc-multilib nasm bc

COPY ./checker ${CHECKER_DATA_DIRECTORY}

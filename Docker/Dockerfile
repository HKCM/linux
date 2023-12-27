FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install -y net-tools \
    && apt-get install -y iputils-ping \
    && apt-get install -y vim wget

COPY .alias /.alias
RUN . /.alias

CMD [ "/bin/bash" ]

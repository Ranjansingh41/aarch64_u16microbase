FROM drydockaarch64/u16:v5.9.2
MAINTAINER Avi "avi@shippable.com"

ENV DEBIAN_FRONTEND noninteractive

ADD . /home/shippable/appBase

RUN /home/shippable/appBase/install.sh && rm -rf /tmp && mkdir /tmp && chmod 1777 /tmp

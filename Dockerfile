FROM ubuntu:latest
#MAINTAINER  <>

# ENV DOKUWIKI_VERSION 2017-02-19b
#ENV DOKUWIKI_VERSION 4f8e7d4306b067959271cb17b43f2949
# ENV DOKUWIKI_CSUM ea11e4046319710a2bc6fdf58b5cda86
#ENV DOKUWIKI_CSUM 1062C8C4A23CF4986307984FFECE0F5C


RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get clean autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}

RUN \
  apt-get update && \
  apt-get -y install mc wget apt-utils && \
  apt-get install -y --no-install-recommends apt-utils && \
  apt-add-repository ppa:ondrej/php

RUN \
  apt-add-repository ppa:ondrej/php && \
  apt-get update && \
  apt-get install -y --no-install-recommends apt-utils && \
  apt-get install -y php php-mysql nginx-full curl && \
  apt-get remove --purge -y $BUILD_PACKAGES && \
  rm -rf /var/lib/apt/lists/* && \
  echo "cgi.fix_pathinfo=0" >> /etc/php/7.0/fpm/php.ini && \
  echo "access.log = /proc/self/fd/2" > /etc/php/7.0/fpm/php-fpm.log && \
  echo "error_log = /proc/self/fd/2" >> /etc/php/7.0/fpm/php-fpm.log


#COPY nginx.conf /etc/nginx/sites-available/default
#COPY Procfile /

EXPOSE 8080

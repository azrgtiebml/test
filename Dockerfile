FROM ubuntu:latest
#MAINTAINER  <>

# ENV DOKUWIKI_VERSION 2017-02-19b
#ENV DOKUWIKI_VERSION 4f8e7d4306b067959271cb17b43f2949
# ENV DOKUWIKI_CSUM ea11e4046319710a2bc6fdf58b5cda86
#ENV DOKUWIKI_CSUM 1062C8C4A23CF4986307984FFECE0F5C

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install mc wget apt-utils vim && \
  apt-get remove --purge -y $BUILD_PACKAGES && \
  apt-get clean autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}

RUN \
  apt-get -y install php7.0-curl php7.0-json php7.0-cgi php7.0 libapache2-mod-php7.0 && \
  apt-get -y install php7.0-xml php7.0-mcrypt php7.0-gd && \
  apt-get remove --purge -y $BUILD_PACKAGES && \
  apt-get clean autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}

#RUN \
#  echo "cgi.fix_pathinfo=0" >> /etc/php/7.0/fpm/php.ini && \
#  echo "access.log = /proc/self/fd/2" > /etc/php/7.0/fpm/php-fpm.log && \
#  echo "error_log = /proc/self/fd/2" >> /etc/php/7.0/fpm/php-fpm.log


#COPY nginx.conf /etc/nginx/sites-available/default
#COPY Procfile /

EXPOSE 8080

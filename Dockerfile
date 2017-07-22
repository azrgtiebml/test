FROM ubuntu:latest

#ENV DOKUWIKI_VERSION 2017-02-19b
ENV DOKUWIKI_VERSION 4f8e7d4306b067959271cb17b43f2949
#ENV DOKUWIKI_CSUM ea11e4046319710a2bc6fdf58b5cda86
ENV DOKUWIKI_CSUM 1062C8C4A23CF4986307984FFECE0F5C


RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y install mc wget apt-utils && \
  apt-get install -y --no-install-recommends apt-utils && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y curl htop man vim mc wget && \

  apt-add-repository ppa:ondrej/php && \
  apt-get -y install nginx && \
  apt-get -y install php7 php7-openssl php7-zlib php7-mbstring php7-fpm php7-gd php7-session php7-xml && \
  apt-get clean autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}


RUN DEBIAN_FRONTEND=noninteractive \
    apt-add-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -y install mc wget apt-utils \
    php7 php7-openssl php7-zlib php7-mbstring php7-fpm php7-gd php7-session php7-xml nginx && \
    apt-get -y upgrade && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/{apt,dpkg,cache,log}

RUN mkdir -p /run/nginx && \
    mkdir -p /var/www /var/dokuwiki-storage/data && \
    cd /var/www && \
    curl -O -L "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    tar -xzf "dokuwiki-$DOKUWIKI_VERSION.tgz" --strip 1 && \
    rm "dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    mv /var/www/data/pages /var/dokuwiki-storage/data/pages && \
    ln -s /var/dokuwiki-storage/data/pages /var/www/data/pages && \
    mv /var/www/data/meta /var/dokuwiki-storage/data/meta && \
    ln -s /var/dokuwiki-storage/data/meta /var/www/data/meta && \
    mv /var/www/data/media /var/dokuwiki-storage/data/media && \
    ln -s /var/dokuwiki-storage/data/media /var/www/data/media && \
    mv /var/www/data/media_attic /var/dokuwiki-storage/data/media_attic && \
    ln -s /var/dokuwiki-storage/data/media_attic /var/www/data/media_attic && \
    mv /var/www/data/media_meta /var/dokuwiki-storage/data/media_meta && \
    ln -s /var/dokuwiki-storage/data/media_meta /var/www/data/media_meta && \
    mv /var/www/data/attic /var/dokuwiki-storage/data/attic && \
    ln -s /var/dokuwiki-storage/data/attic /var/www/data/attic && \
    mv /var/www/conf /var/dokuwiki-storage/conf && \
    ln -s /var/dokuwiki-storage/conf /var/www/conf

ADD nginx.conf /etc/nginx/nginx.conf
ADD start.sh /start.sh

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php7/php-fpm.ini && \
    sed -i -e "s|;daemonize\s*=\s*yes|daemonize = no|g" /etc/php7/php-fpm.conf && \
    sed -i -e "s|listen\s*=\s*127\.0\.0\.1:9000|listen = /var/run/php-fpm7.sock|g" /etc/php7/php-fpm.d/www.conf && \
    sed -i -e "s|;listen\.owner\s*=\s*\w*|listen.owner = nginx|g" /etc/php7/php-fpm.d/www.conf && \
    sed -i -e "s|;listen\.owner\s*=\s*\w*|listen.owner = nginx|g" /etc/php7/php-fpm.d/www.conf && \
    sed -i -e "s|;user\s*=\s*\w*|user = nginx|g" /etc/php7/php-fpm.d/www.conf && \
    sed -i -e "s|;listen\.mode\s*=\s*|listen.mode = |g" /etc/php7/php-fpm.d/www.conf && \
    chmod +x /start.sh

EXPOSE 8080
VOLUME ["/var/dokuwiki-storage"]

CMD /start.sh

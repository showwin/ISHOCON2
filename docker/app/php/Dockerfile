ARG BASE_IMAGE=showwin/ishocon2_app_base:latest
FROM ${BASE_IMAGE}

# PHP のインストール
RUN sudo mkdir /run/php
RUN sudo apt-get update
RUN sudo apt install -y php php-fpm php-mysql php-cli

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

WORKDIR /home/ishocon

RUN cd webapp/php && \
    sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    sudo php composer-setup.php && \
    sudo php composer.phar install && \
    sudo php -r "unlink('composer-setup.php');"

RUN sudo mv -f /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig && \
    sudo cp /home/ishocon/webapp/php/php-nginx.conf /etc/nginx/nginx.conf

COPY run.sh /home/ishocon/run.sh

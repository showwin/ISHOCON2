ARG BASE_IMAGE=showwin/ishocon2_app_base:latest
FROM ${BASE_IMAGE}

# PHP のインストール
RUN sudo mkdir /run/php
RUN sudo apt-get update
RUN sudo apt install -y php php-fpm php-mysql php-cli

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

# ライブラリのインストール
RUN cd /home/ishocon/webapp/php && \
    sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    sudo php composer-setup.php && \
    sudo php composer.phar install && \
    sudo php -r "unlink('composer-setup.php');"

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

CMD cd ~/webapp/php && \
    sudo mv -f /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig && \
    sudo cp /home/ishocon/webapp/php/php-nginx.conf /etc/nginx/nginx.conf && \
    sudo service nginx reload && \
    sudo service php7.2-fpm restart

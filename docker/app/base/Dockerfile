FROM ubuntu:18.04

ENV LANG en_US.UTF-8

RUN apt-get update
RUN apt-get install -y wget sudo less vim tzdata

# ishocon ユーザ作成
RUN groupadd -g 1001 ishocon && \
    useradd  -g ishocon -G sudo -m -s /bin/bash ishocon && \
    echo 'ishocon:ishocon' | chpasswd
RUN echo 'ishocon ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# MySQL のインストール
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-server mysql-server/root_password password ishocon'"]
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-service mysql-server/mysql-apt-config string 4'"]
RUN apt-get install -y mysql-server

# Nginx のインストール
RUN apt-get install -y nginx
COPY admin/ssl/ /etc/nginx/ssl/
COPY admin/config/nginx.conf /etc/nginx/nginx.conf

# 各言語のインストールに必要なもの下準備
RUN apt-get install -y curl git gcc make libssl-dev libreadline-dev

USER ishocon

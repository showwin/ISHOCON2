ARG BASE_IMAGE=ubuntu:18.04
FROM ${BASE_IMAGE}


USER root

ENV LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y sudo wget less vim tzdata nginx \
    # 各言語のインストールに必要なもの下準備 \
    curl git gcc make libssl-dev libreadline-dev && \
    apt-get clean

# ishocon ユーザ作成
RUN groupadd -g 1001 ishocon && \
    useradd  -g ishocon -G sudo -m -s /bin/bash ishocon && \
    echo 'ishocon:ishocon' | chpasswd
RUN echo 'ishocon ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# *env 系の設定が入った .bashrc のコピー
COPY admin/config/bashrc /home/ishocon/.bashrc

# Nginx の設定
COPY admin/ssl/ /etc/nginx/ssl/
COPY admin/config/nginx.conf /etc/nginx/nginx.conf

# MySQL のインストールと dump, cnf の配置
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-server mysql-server/root_password password ishocon'"]
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ishocon'"]
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-service mysql-server/mysql-apt-config string 4'"]
RUN apt-get install -y mysql-server
RUN mkdir -m 777 /home/ishocon/data
COPY admin/ishocon2.dump.tar.bz2 /home/ishocon/data/ishocon2.dump.tar.bz2
COPY admin/config/my.app.cnf /etc/mysql/my.cnf

USER ishocon

EXPOSE 3306 443

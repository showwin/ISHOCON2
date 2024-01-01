FROM ubuntu:18.04

RUN sudo apt-get update
RUN apt-get install -y wget

# TZ の設定
ENV TZ Asia/Tokyo

# 日本語の設定
RUN sudo apt-get install -y language-pack-ja && \
    sudo update-locale LANG=ja_JP.UTF-8 && \
    sudo rm -rf /var/lib/apt/lists/*
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# Go のインストール
RUN wget -q https://dl.google.com/go/go1.13.15.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.13.15.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOROOT /usr/local/go
ENV GOPATH $HOME/.local/go
ENV PATH $PATH:$GOROOT/bin

# MySQL のインストール
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-server mysql-server/root_password password ishocon'"]
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-service mysql-server/mysql-apt-config string 4'"]

RUN sudo apt-get update && \
    apt-get install -y mysql-server

COPY admin/ /root/admin/

# build benchmark
RUN apt-get install -y git
RUN cd /root/admin/benchmarker && go build -o benchmark *.go
RUN cp /root/admin/benchmarker/benchmark /root/benchmark

# MySQL 初期設定
RUN cp /root/admin/config/my.cnf /etc/mysql/my.cnf

WORKDIR /root

COPY docker/benchmarker/entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]

CMD /root/benchmark --ip $TARGET:443

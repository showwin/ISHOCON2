ARG BASE_IMAGE=showwin/ishocon2_app_base:latest
FROM ${BASE_IMAGE}

# Ruby のインストール
RUN sudo apt-get update && \
    sudo apt-get install -y ruby-dev libmysqlclient-dev libffi6 libffi-dev libyaml-dev bzip2 && \
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN PATH="$HOME/.rbenv/bin:$PATH" && \
    eval "$(rbenv init -)" && \
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    rbenv install 3.2.2 && rbenv rehash && rbenv global 3.2.2

WORKDIR /home/ishocon

# install tools for analyze
RUN sudo apt-get install -y percona-toolkit

ARG TARGETARCH

# install alp
RUN sudo curl -L -O https://github.com/tkuchiki/alp/releases/download/v1.0.21/alp_linux_${TARGETARCH}.zip && \
    sudo unzip alp_linux_${TARGETARCH}.zip && \
    sudo rm -rf unzip alp_linux_${TARGETARCH}.zip && \
    sudo mv alp /usr/local/bin/ && \
    alp --version

ENV RUBY_YJIT_ENABLE=1

# 頻繁に書き換えるファイルのコピー
COPY admin/config/my.app.cnf /etc/mysql/my.cnf
COPY admin/config/nginx.conf /etc/nginx/nginx.conf

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

# pt-query-digest 用のスクリプト配置
COPY --chown=ishocon:ishocon --chmod=777 scripts/ /home/ishocon/scripts/

COPY run.sh /home/ishocon/run.sh

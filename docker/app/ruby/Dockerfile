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

ENV RUBY_YJIT_ENABLE=1

# MySQL の設定（頻繁に書き換えるので base じゃなくてここで COPY）
COPY admin/config/my.app.cnf /etc/mysql/my.cnf

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

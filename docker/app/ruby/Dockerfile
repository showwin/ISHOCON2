FROM showwin/ishocon2_app_base:latest
ENV APP_LANG 'Ruby'

# TZ の設定
ENV TZ Asia/Tokyo

RUN sudo apt-get update

# 日本語の設定
RUN sudo apt-get install -y language-pack-ja htop && \
    sudo update-locale LANG=ja_JP.UTF-8 && \
    sudo rm -rf /var/lib/apt/lists/*
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# Ruby のインストール
RUN sudo apt-get update && \
    sudo apt-get install -y ruby-dev libmysqlclient-dev libffi6 libffi-dev libyaml-dev && \
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN PATH="$HOME/.rbenv/bin:$PATH" && \
    eval "$(rbenv init -)" && \
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    rbenv install 3.2.2 && rbenv rehash && rbenv global 3.2.2

# YJIT の有効化
ENV RUBY_YJIT_ENABLE=1

# アプリケーション
RUN mkdir /home/ishocon/data /home/ishocon/webapp
COPY admin/ishocon2.dump.tar.bz2 /home/ishocon/data/ishocon2.dump.tar.bz2
COPY webapp/ /home/ishocon/webapp
COPY admin/config/bashrc /home/ishocon/.bashrc

# 静的ファイルの配置（nginx が読めるように）
COPY --chown=www-data:www-data public /home/ishocon/public

# base をビルドし直しても変更されなかったのでここでも改めてコピーする
COPY admin/config/nginx.conf /etc/nginx/nginx.conf

# ライブラリのインストール
RUN cd /home/ishocon/webapp/ruby && \
    . /home/ishocon/.bashrc && \
    bash ./set_up_ruby.sh

WORKDIR /home/ishocon
EXPOSE 443

COPY run.sh /home/ishocon/run.sh

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

CMD cd ~/webapp/ruby && unicorn -c unicorn_config.rb

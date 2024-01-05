ARG BASE_IMAGE=showwin/ishocon2_app_base:latest
FROM ${BASE_IMAGE}

# Ruby のインストール
RUN sudo apt-get update && \
    sudo apt-get install -y ruby-dev libmysqlclient-dev libffi6 libffi-dev libyaml-dev bzip2 && \
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN PATH="$HOME/.rbenv/bin:$PATH" && \
    eval "$(rbenv init -)" && \
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    rbenv install 2.5.1 && rbenv rehash && rbenv global 2.5.1

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

WORKDIR /home/ishocon

# ライブラリのインストール
RUN . ~/.bashrc && \
    gem environment && \
    cd /home/ishocon/webapp/ruby && \
    gem install bundler -v "1.16.1" &&  \
    bundle install

COPY run.sh /home/ishocon/run.sh

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

CMD cd ~/webapp/ruby && unicorn -c unicorn_config.rb

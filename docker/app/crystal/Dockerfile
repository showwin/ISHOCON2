ARG BASE_IMAGE=showwin/ishocon2_app_base:latest
FROM ${BASE_IMAGE}

# Crystal のインストール
RUN sudo apt-get update
RUN sudo apt install -y libssl1.0-dev gnupg2
RUN curl -fsSL https://crystal-lang.org/install.sh | sudo bash

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

# FIXME: エラーで立ち上がらない
CMD cd ~/webapp/crystal && shards install && crystal app.cr

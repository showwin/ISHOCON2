FROM showwin/ishocon2_app_base:latest
ENV APP_LANG 'Crystal'

# Crystal のインストール
RUN sudo apt-get update
RUN sudo apt install -y libssl1.0-dev gnupg2
RUN curl -fsSL https://crystal-lang.org/install.sh | sudo bash

# アプリケーション
RUN mkdir /home/ishocon/data /home/ishocon/webapp
COPY admin/ishocon2.dump.tar.bz2 /home/ishocon/data/ishocon2.dump.tar.bz2
COPY webapp/ /home/ishocon/webapp
COPY admin/config/bashrc /home/ishocon/.bashrc

WORKDIR /home/ishocon
EXPOSE 443

COPY run.sh /home/ishocon/run.sh

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

# FIXME: エラーで立ち上がらない
CMD cd ~/webapp/crystal && shards install && crystal app.cr

FROM showwin/ishocon2_app_base:latest
ENV APP_LANG 'Node.js'

# NodeJS のインストール
RUN sudo apt-get update
RUN sudo apt install -y nodejs-dev node-gyp libssl1.0-dev
RUN sudo apt install -y nodejs npm

# アプリケーション
RUN mkdir /home/ishocon/data /home/ishocon/webapp
COPY admin/ishocon2.dump.tar.bz2 /home/ishocon/data/ishocon2.dump.tar.bz2
COPY webapp/ /home/ishocon/webapp
COPY admin/config/bashrc /home/ishocon/.bashrc

# ライブラリのインストール
RUN cd /home/ishocon/webapp/nodejs && \
    sudo npm install

WORKDIR /home/ishocon
EXPOSE 443

COPY run.sh /home/ishocon/run.sh

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

CMD cd ~/webapp/nodejs && npm install && node index.js

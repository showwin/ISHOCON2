ARG BASE_IMAGE=showwin/ishocon2_app_base:latest
FROM ${BASE_IMAGE}

# NodeJS のインストール
RUN sudo apt-get update
RUN sudo apt install -y nodejs-dev node-gyp libssl1.0-dev
RUN sudo apt install -y nodejs npm

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

# ライブラリのインストール
RUN cd /home/ishocon/webapp/nodejs && \
    sudo npm install

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

CMD cd ~/webapp/nodejs && npm install && node index.js

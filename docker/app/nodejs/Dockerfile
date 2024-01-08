ARG BASE_IMAGE=ishocon2-app-base:latest
FROM ${BASE_IMAGE}

# NodeJS のインストール
RUN sudo apt-get update
RUN sudo apt install -y nodejs-dev node-gyp libssl1.0-dev \
    nodejs npm && \
    sudo apt-get clean

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

# ライブラリのインストール
RUN cd /home/ishocon/webapp/nodejs && \
    npm install

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

ARG BASE_IMAGE=showwin/ishocon2_app_base:latest
FROM ${BASE_IMAGE}

RUN sudo apt update && \
    sudo apt install -y \
    gnupg2

# Crystal のインストール
# ref: https://packagecloud.io/84codes/crystal
RUN curl -fsSL https://packagecloud.io/84codes/crystal/gpgkey | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/84codes_crystal.gpg > /dev/null && \
    . /etc/os-release && \
    echo "deb https://packagecloud.io/84codes/crystal/$ID $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/84codes_crystal.list && \
    sudo apt-get update && \
    sudo apt-get install -y crystal

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp
RUN cd ~/webapp/crystal && shards install

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

# FIXME: エラーで立ち上がらない
CMD crystal app.cr

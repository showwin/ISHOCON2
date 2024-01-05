ARG BASE_IMAGE=showwin/ishocon2_app_base:latest
FROM ${BASE_IMAGE}

# Go のインストール
ARG TARGETARCH
ENV GOARCH ${TARGETARCH}

RUN sudo apt-get update

# Go のインストール
ARG TARGETARCH
RUN sudo wget -q https://dl.google.com/go/go1.15.8.linux-${TARGETARCH}.tar.gz && \
    sudo tar -C /usr/local -xzf go1.15.8.linux-${TARGETARCH}.tar.gz && \
    sudo rm go1.15.8.linux-${TARGETARCH}.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOROOT /usr/local/go
ENV GOPATH $HOME/.local/go
ENV PATH $PATH:$GOROOT/bin

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

CMD cd ~/webapp/go && GOARCH=${TARGETARCH} go build -x -o webapp *.go && ./webapp

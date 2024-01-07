FROM showwin/ishocon2_app_base:latest

# Go のインストール
ARG TARGETARCH
ENV GOARCH ${TARGETARCH}

# Go のインストール
ARG TARGETARCH
RUN sudo wget -q https://dl.google.com/go/go1.15.8.linux-${TARGETARCH}.tar.gz && \
    sudo tar -C /usr/local -xzf go1.15.8.linux-${TARGETARCH}.tar.gz && \
    sudo rm go1.15.8.linux-${TARGETARCH}.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOROOT /usr/local/go
ENV GOPATH /home/ishocon/.local/go
ENV PATH $PATH:$GOROOT/bin

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp
RUN cd ~/webapp/go && \
    mkdir -p /tmp/go && \
    go build -x -o /tmp/go/webapp *.go

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

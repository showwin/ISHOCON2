ARG BASE_IMAGE=ubuntu:18.04
FROM ${BASE_IMAGE}

ENV LANG en_US.UTF-8
ENV LC_ALL=C.UTF-8
ENV TZ Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# MySQL のインストール
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-server mysql-server/root_password password ishocon'"]
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-service mysql-server/mysql-apt-config string 4'"]

RUN apt-get update && \
    apt-get install -y wget mysql-server git tzdata

# Go のインストール
ARG TARGETARCH
RUN wget -q https://dl.google.com/go/go1.13.15.linux-${TARGETARCH}.tar.gz && \
    tar -C /usr/local -xzf go1.13.15.linux-${TARGETARCH}.tar.gz && \
    rm go1.13.15.linux-${TARGETARCH}.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOROOT /usr/local/go
ENV GOPATH $HOME/.local/go
ENV PATH $PATH:$GOROOT/bin

# build benchmark
COPY admin/benchmarker /root/admin/benchmarker
RUN cd /root/admin/benchmarker &&  \
    GOARCH=${TARGETARCH} go build -x -o ../../benchmark *.go

# MySQL 初期設定
COPY admin/ishocon2.dump.tar.bz2 /root/admin/ishocon2.dump.tar.bz2
COPY admin/config/my.bench.cnf /etc/mysql/my.cnf

WORKDIR /root

COPY docker/benchmarker/entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]

CMD /root/benchmark --ip $TARGET:443

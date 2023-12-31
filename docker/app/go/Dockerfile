FROM showwin/ishocon2_app_base:latest
ENV APP_LANG 'Go'

# Go のインストール
RUN sudo wget -q https://dl.google.com/go/go1.15.8.linux-amd64.tar.gz && \
    sudo tar -C /usr/local -xzf go1.15.8.linux-amd64.tar.gz && \
    sudo rm go1.15.8.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOROOT /usr/local/go
ENV GOPATH /home/ishocon/.local/go
ENV PATH $PATH:$GOROOT/bin

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

CMD cd ~/webapp/go && go build -o webapp *.go && ./webapp

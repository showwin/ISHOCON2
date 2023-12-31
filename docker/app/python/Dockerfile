FROM showwin/ishocon2_app_base:latest
ENV APP_LANG 'Python'

# Python のインストール
RUN sudo apt-get update
RUN sudo apt-get install -y zlib1g-dev
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    PYENV_ROOT="$HOME/.pyenv" && PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    pyenv install 3.6.5 && pyenv global 3.6.5 && \
    cd && curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py && python get-pip.py && rm get-pip.py

# アプリケーション
RUN mkdir /home/ishocon/data /home/ishocon/webapp
COPY admin/ishocon2.dump.tar.bz2 /home/ishocon/data/ishocon2.dump.tar.bz2
COPY webapp/ /home/ishocon/webapp
COPY admin/config/bashrc /home/ishocon/.bashrc

# ライブラリのインストール
RUN sudo apt-get install -y libmysqlclient-dev
RUN LC_ALL=C.UTF-8 && LANG=C.UTF-8 && cd /home/ishocon/webapp/python && \
    /home/ishocon/.pyenv/shims/pip install -r requirements.txt

WORKDIR /home/ishocon
EXPOSE 443

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

CMD cd ~/webapp/python && /home/ishocon/.pyenv/shims/uwsgi --ini app.ini

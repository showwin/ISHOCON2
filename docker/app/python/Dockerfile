ARG BASE_IMAGE=ishocon2-app-base:latest
FROM ${BASE_IMAGE}

# Python のインストール
RUN sudo apt-get update && \
    sudo apt-get install -y zlib1g-dev && \
    sudo apt-get clean
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    PYENV_ROOT="$HOME/.pyenv" && PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    pyenv install 3.6.5 && pyenv global 3.6.5 && \
    cd && curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py && python get-pip.py && rm get-pip.py

# アプリケーション
COPY --chown=ishocon:ishocon webapp/ /home/ishocon/webapp

# ライブラリのインストール
RUN sudo apt-get install -y libmysqlclient-dev
RUN LC_ALL=C.UTF-8 && LANG=C.UTF-8 && cd /home/ishocon/webapp/python && \
    /home/ishocon/.pyenv/shims/pip install -r requirements.txt

WORKDIR /home/ishocon

COPY run.sh /home/ishocon/run.sh

#!/bin/bash -eux

app_lang="${ISHOCON_APP_LANG}"

if [ -z "$app_lang" ]
then
  echo "ISHOCON_APP_LANG is not set"
  exit 1
fi

echo "app_lang: $app_lang"

function make_tmp_file() {
  touch /tmp/ishocon-app
}

function run_ruby() {
  cd "/home/ishocon/webapp/$app_lang"
  make_tmp_file
  # add sudo for .pid file is not created somehow because of permission denied
  sudo unicorn -c unicorn_config.rb
}

function run_python() {
  cd "/home/ishocon/webapp/$app_lang"
  make_tmp_file
  /home/ishocon/.pyenv/shims/uwsgi --ini app.ini
}

function run_go() {
  cd "/home/ishocon/webapp/$app_lang"
  # put output file into /tmp/go for it cannot be created in webapp somehow because of permission denied
  mkdir -p /tmp/go
  go build -o /tmp/go/webapp *.go
  make_tmp_file
  /tmp/go/webapp
}

function run_php() {
  cd "/home/ishocon/webapp/$app_lang"
  sudo mv -f /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
  sudo cp /home/ishocon/webapp/php/php-nginx.conf /etc/nginx/nginx.conf
  make_tmp_file
  sudo service nginx reload
}

function run_nodejs() {
  cd "/home/ishocon/webapp/$app_lang"
  # express cannot be found somehow, so install it globally
  # (running from npm script also failed)
  sudo npm install -g express@4.16.3
  make_tmp_file
  sudo node index.js
}

function run_crystal() {
  cd "/home/ishocon/webapp/$app_lang"
  shards install
  make_tmp_file
  crystal app.cr
}

echo "starting running $app_lang app..."
"run_${app_lang}"

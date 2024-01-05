#!/bin/bash -eux

app_lang="${ISHOCON_APP_LANG}"

if [ -z "$app_lang" ]
then
  echo "ISHOCON_APP_LANG is not set"
  exit 1
fi

check_message="start application w/ ${app_lang}..."

source /home/ishocon/.bashrc

echo "app_lang: $app_lang"

function make_tmp_file() {
  touch /tmp/ishocon-app
  echo "$check_message"
}

function run_ruby() {
  cd "/home/ishocon/webapp/$app_lang"
  sudo rm -rf /tmp/unicorn.pid
  make_tmp_file
  unicorn -c unicorn_config.rb
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
  sudo service nginx reload
  sudo service php7.2-fpm restart
  make_tmp_file
  tail -f /dev/null
}

function run_nodejs() {
  cd "/home/ishocon/webapp/$app_lang"
  sudo npm install
  make_tmp_file
  sudo node index.js
}

function run_crystal() {
  cd "/home/ishocon/webapp/$app_lang"
  sudo shards install
  make_tmp_file
  sudo crystal app.cr
}

echo "starting running $app_lang app..."
"run_${app_lang}"

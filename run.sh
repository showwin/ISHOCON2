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

function run_ruby() {
  rbenv global 3.1.4
  unicorn -c unicorn_config.rb
  echo "$check_message"
}

function run_python() {
  /home/ishocon/.pyenv/shims/uwsgi --ini app.ini
  echo "$check_message"
}

function run_python_sanic() {
  /home/ishocon/.pyenv/shims/uwsgi --ini app.ini
  echo "$check_message"
}


function run_go() {
  go get -t -d -v ./...
  go build -o webapp *.go
  ./webapp
  echo "$check_message"
}

function run_php() {
  sudo mv -f /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
  sudo cp /home/ishocon/webapp/php/php-nginx.conf /etc/nginx/nginx.conf
  sudo service nginx reload
  echo "$check_message"
}

function run_crystal() {
  shards install
  crystal app.cr
  echo "$check_message"
}

echo "run $app_lang app..."
cd "/home/ishocon/webapp/$app_lang"

"run_$app_lang"

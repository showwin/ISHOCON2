#!/bin/bash -eux

app_lang="${ISHOCON_APP_LANG}"

if [ -z "$app_lang" ]
then
  echo "ISHOCON_APP_LANG is not set"
  exit 1
fi

echo "app_lang: $app_lang"

function run_ruby() {
  cd "/home/ishocon/webapp/$app_lang"
  bundle install
  unicorn -c unicorn_config.rb
  echo $check_message
}

function run_python() {
  cd "/home/ishocon/webapp/$app_lang"
  /home/ishocon/.pyenv/shims/uwsgi --ini app.ini
}

function run_python_sanic() {
  cd "/home/ishocon/webapp/${app_lang}_sanic"
  /home/ishocon/.pyenv/shims/uwsgi --ini "app.ini"
}


function run_go() {
  cd "/home/ishocon/webapp/$app_lang"
  go get -t -d -v ./...
  go build -o webapp *.go
  ./webapp
}

function run_php() {
  cd "/home/ishocon/webapp/$app_lang"
  sudo mv -f /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
  sudo cp webapp/php/php-nginx.conf /etc/nginx/nginx.conf
  sudo service nginx reload
}

function run_crystal() {
  cd "/home/ishocon/webapp/$app_lang"
  shards install
  crystal app.cr
}

echo "start running $app_lang app..."
"run_${app_lang}"
echo "completed to start running $app_lang app..."


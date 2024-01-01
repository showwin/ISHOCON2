#!/bin/bash -eux

app_lang="${ISHOCON_APP_LANG}"

# start mysql incase of if it not started
sudo service mysql start

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
  go build -o webapp *.go
  make_tmp_file
  ./webapp
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
  make_tmp_file
  npm run express
}

function run_crystal() {
  cd "/home/ishocon/webapp/$app_lang"
  make_tmp_file
  crystal app.cr
}

echo "starting running $app_lang app..."
"run_${app_lang}"

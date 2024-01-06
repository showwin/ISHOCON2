#!/bin/bash -eux

app_lang="${ISHOCON_APP_LANG}"

if [ -z "$app_lang" ]
then
  echo "ISHOCON_APP_LANG is not set"
  exit 1
fi

echo "start installing pt-query-digest..."
sudo apt-get install -y percona-toolkit
echo "pt-query-digest installed."

echo "starting nginx and mysql..."
cd /home/ishocon
sudo nginx -t
sudo service nginx start
sudo chown -R mysql:mysql /var/lib/mysql
sudo service mysql start
echo "nginx and mysql started."

echo "setting up mysql user..."
sudo mysql -u root -pishocon -e 'CREATE DATABASE IF NOT EXISTS ishocon2;'
sudo mysql -u root -pishocon -e "CREATE USER IF NOT EXISTS ishocon IDENTIFIED BY 'ishocon';"
sudo mysql -u root -pishocon -e 'GRANT ALL ON *.* TO ishocon;'
echo "mysql user set up completed."

echo "importing data..."
tar -jxvf ~/data/ishocon2.dump.tar.bz2 -C ~/data && sudo mysql -u root -pishocon ishocon2 < ~/data/ishocon2.dump
echo "data imported."

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
  gem install bundler -v "1.16.1"
  bundle install
  make_tmp_file
  bundle exec unicorn -c unicorn_config.rb
}

function run_python() {
  cd "/home/ishocon/webapp/$app_lang"
  make_tmp_file
  /home/ishocon/.pyenv/shims/uwsgi --ini app.ini
}

function run_go() {
  cd "/home/ishocon/webapp/$app_lang"
  make_tmp_file
  /tmp/go/webapp
}

function run_php() {
  cd "/home/ishocon/webapp/$app_lang"
  sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  sudo php composer-setup.php && \
  sudo php composer.phar install && \
  sudo php -r "unlink('composer-setup.php');"
  sudo service php7.2-fpm restart
  make_tmp_file
  sudo tail -f /var/log/nginx/access.log /var/log/nginx/error.log
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

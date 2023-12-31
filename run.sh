#!/bin/bash -eux

app_lang="${ISHOCON_APP_LANG:-"python"}"

check_message="start application..."

sleep 10
echo "Ready."

echo "app_lang: $app_lang"

function run_ruby() {
  echo "run python app..."
  cd ~/webapp/ruby
  unicorn -c unicorn_config.rb
  echo "$check_message"
}

function run_python() {
  echo "run ruby app..."
  cd ~/webapp/ruby
  echo "$check_message"
  bundle exec puma -C config_puma.rb
}

function run_go() {
  echo "run go app..."
  cd ~/webapp/go
  go build -o /tmp/webapp
  ./webapp
  echo "$check_message"
}

function run_nodejs() {
  echo "run nodejs app..."
  node index.js
  echo "$check_message"
}

function run_crystal() {
  echo "run crystal app..."
  crystal app.cr
  echo "$check_message"
}

"run_$app_lang"

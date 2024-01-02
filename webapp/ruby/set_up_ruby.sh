#!/bin/bash -eux

cd /home/ishocon/webapp/ruby
gem install bundler -v "2.5.3"
sudo chown -R "$(whoami):$(whoami)" /home/ishocon/webapp/ruby
bundle install

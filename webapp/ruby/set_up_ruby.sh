#!/bin/bash -eux

cd /home/ishocon/webapp/ruby
gem install bundler -v "2.5.3"
bundle install
rbenv rehash

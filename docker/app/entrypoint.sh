#!/bin/bash -eux

cd /home/ishocon
sudo nginx -t && \
sudo service nginx start && \
sudo service mysql start && \
sudo mysql -u root -pishocon -e 'CREATE DATABASE IF NOT EXISTS ishocon2;' && \
sudo mysql -u root -pishocon -e "CREATE USER IF NOT EXISTS ishocon IDENTIFIED BY 'ishocon';" && \
sudo mysql -u root -pishocon -e 'GRANT ALL ON *.* TO ishocon;' && \
tar -jxvf ~/data/ishocon2.dump.tar.bz2 -C ~/data && sudo mysql -u root -pishocon ishocon2 < ~/data/ishocon2.dump

echo 'setup completed.'

exec "$@"

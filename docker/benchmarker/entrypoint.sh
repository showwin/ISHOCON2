#!/bin/bash -ux

service mysql start && \
mysql -u root -pishocon -e 'CREATE DATABASE IF NOT EXISTS ishocon2;' && \
mysql -u root -pishocon -e "CREATE USER IF NOT EXISTS ishocon IDENTIFIED BY 'ishocon';" && \
mysql -u root -pishocon -e 'GRANT ALL ON *.* TO ishocon;' && \
tar -jxvf ~/admin/ishocon2.dump.tar.bz2 -C ~/admin && mysql -u root -pishocon ishocon2 < ~/admin/ishocon2.dump

echo 'setup completed.'

exec "$@"

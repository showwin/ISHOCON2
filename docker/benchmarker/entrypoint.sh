#!/bin/bash -ux

service mysql start  # なぜか失敗する(調査中)
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
service mysql start  # 正しく起動
mysql -u root -pishocon -e 'CREATE DATABASE IF NOT EXISTS ishocon2;' && \
mysql -u root -pishocon -e "CREATE USER IF NOT EXISTS ishocon IDENTIFIED BY 'ishocon';" && \
mysql -u root -pishocon -e 'GRANT ALL ON *.* TO ishocon;' && \
cd /root/admin && tar -jxvf ishocon2.dump.tar.bz2 && mysql -u root -pishocon ishocon2 < /root/admin/ishocon2.dump

echo 'setup completed.'

exec "$@"

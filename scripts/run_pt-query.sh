#!/bin/bash -eux

rm -rf sloq-query.log.analyzed
pt-query-digest --type slowlog /var/log/mysql/slow-query.log > slow-query.log.analyzed
rm -rf /var/log/mysql/slow-query.log

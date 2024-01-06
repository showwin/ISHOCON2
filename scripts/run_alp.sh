#!/bin/bash -eux

sudo cat /var/log/nginx/access.log | alp ltsv --sort sum -o count,2xx,3xx,4xx,5xx,method,uri,avg,sum
rm -rf /var/log/nginx/access.log

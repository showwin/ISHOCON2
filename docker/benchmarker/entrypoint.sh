#!/bin/bash -ux

service mysql restart

echo 'setup completed.'

exec "$@"

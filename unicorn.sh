#!/bin/bash
exec 2>&1
chown -R discourse:www-data /shared/log/rails
LD_PRELOAD=/usr/lib/libjemalloc.so.1 HOME=/usr/src/app USER=discourse \
    bundle exec config/unicorn_launcher -E production -c config/unicorn.conf.rb

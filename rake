#!/bin/bash
(cd /var/www/discourse && RAILS_ENV=production sudo -H -E -u discourse bundle exec bin/rake "$@")

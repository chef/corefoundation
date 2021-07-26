#!/bin/bash

set -ue

export USER="root"

echo "--- bundle install"

bundle config set --local path vendor/bundle
bundle install --jobs=5 --retry=3

echo "--- bundle exec task"
bundle exec $@

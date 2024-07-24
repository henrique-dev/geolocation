#!/bin/bash
set -e

mkdir -p tmp/pids
rm -f tmp/pids/server.pid

bundle exec rails db:prepare

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

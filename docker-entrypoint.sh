#!/bin/sh

set -e

while ! nc -z ${DATABASE_HOST} ${DATABASE_PORT}; do echo "DB not ready" && sleep 1; done;

mix ecto.bootstrap
mix phx.server

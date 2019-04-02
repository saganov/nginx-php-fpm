#!/bin/sh

nginx
status=$?
if [ "$status" -ne 0 ]; then
  echo "Failed to start NGINX: $status"
  exit "$status"
fi

php-fpm&
status=$?
if [ "$status" -ne 0 ]; then
  echo "Failed to start PHP-FPM: $status"
  exit "$status"
fi

while sleep 60; do
  ps aux | grep php-fpm | grep -q -v grep
  PHP_FPM_STATUS=$?
  ps aux | grep nginx |grep -q -v grep
  NGINX_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ "$PHP_FPM_STATUS" -ne 0 -o "$NGINX_STATUS" -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done

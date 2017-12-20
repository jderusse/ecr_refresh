#!/usr/bin/env sh

docker version > /dev/null
if [ $? -ne 0 ]; then
  echo 'Docker socket is not usable'
  exit 1
fi

region=$1
shift

while true; do
  if [ "$#" -gt 0 ]; then
    $(aws ecr get-login --no-include-email --region $region --registry-ids "$@")
  else
    $(aws ecr get-login --no-include-email --region $region)
  fi
  sleep 14400
done

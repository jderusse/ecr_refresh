#!/usr/bin/env sh

usage ()
{
  echo 'usage: docker service create \
       --name refresh_token \
       --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,readonly=false \
       --mount type=bind,source=/home/docker,target=/home/docker,readonly=false \
       --mode global \
       --user docker \
       jderusse/ecr_refresh:latest \
       eu-west-1 [ registry-id1 registry-id2]'
  exit 1
}

if [ "$#" -lt 1 ]; then
  usage
fi

docker version > /dev/null
if [ $? -ne 0 ]; then
  usage
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

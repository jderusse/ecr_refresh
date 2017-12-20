#!/usr/bin/env sh

usage ()
{
  echo 'Usage : docker service create \
       --name ecr_refresh \
       --mount type=bind,src=/var/run/docker.sock:/var/run/docker.sock \
       --mount type=bind,src=/home/docker/.docker/config.json:/root/.docker/config.json \
       --mode global \
       jderusse/ecr_refresh \
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

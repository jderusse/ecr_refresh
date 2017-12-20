#!/usr/bin/env sh

usage ()
{
  echo 'usage: docker service create \
       --name refresh_token \
       --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,readonly=false \
       --mount type=bind,source=/home/docker,target=/home/docker,readonly=false \
       --mode global \
       --detach false \
       jderusse/ecr_refresh:latest \
       eu-west-1 [ registry-id1 registry-id2]'
  exit 1
}

if [ "$#" -lt 1 ]; then
  usage
fi

USER=host
GROUP_ID=$(stat -c '%g' /home/docker)
USER_ID=$(stat -c '%u' /home/docker)
if [ ! $(getent group ${GROUP_ID}) ]; then
  groupadd -g ${GROUP_ID} ${USER}
fi

if [ ! $(getent passwd ${USER_ID}) ]; then
  useradd -u ${USER_ID} -g ${GROUP_ID} -K UID_MAX=9999999999 --home-dir /home/docker ${USER}
fi

usermod -aG ${GROUP_ID} ${USER}

su-exec ${USER} run.sh "$@"

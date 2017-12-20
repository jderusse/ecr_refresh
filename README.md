# ECR Refresh

A docker image to refresh AWS ECR token every 4Hours as a workaround
for https://github.com/docker/for-aws/issues/5

## How it works

The container just performs a `$(aws ecr get-login)` to refresh the registry
credentials.
By mounting the host volume `/home/docker/.docker/config.json` the new
credentials will be stored in the host's config file and be used when the host
needs to performs a docker pull on that registry.

## Usage

```
docker service create \
     --name refresh_token \
     --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,readonly=false \
     --mount type=bind,source=/home/docker,target=/home/docker,readonly=false \
     --mode global \
     --detach false \
     jderusse/ecr_refresh:latest \
     eu-west-1 [ registry-id1 registry-id2]
```

## Configuration

To be allowed to retrieves new credentials, each node must have a role with
the permission `AmazonEC2ContainerRegistryReadOnly`

#! /bin/bash

set -e

docker build --tag edgyr/v8-bionic-arm64:latest --file Dockerfile .
echo 'Ignore "no such container" errors'
docker rm --force v8-container || true
docker run -it --name v8-container edgyr/v8-bionic-arm64:latest tar -tvf /v8-8.3.110.13-static.tar.xz
docker cp v8-container:/v8-8.3.110.13-static.tar.xz .

#! /bin/bash

set -e

docker build --tag v8-bionic-arm64:latest --file Dockerfile .
docker run --name v8-bionic-arm64 v8-bionic-arm64:latest
docker cp v8-bionic-arm64:/v8-8.3.110.13-static.tar.xz .
tar tvf v8-8.3.110.13-static.tar.xz

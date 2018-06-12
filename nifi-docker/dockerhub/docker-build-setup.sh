#!/bin/bash

set -exuo pipefail

VERSION=$1
PORT=${2:-18081}

NAME=${3:-nifi-docker-test-repo-$VERSION}

if [ -n "$(docker ps -q --filter name=$NAME)" ]; then
    docker rm -f $NAME
fi

echo "Generating sha256 checksum inside a busybox container for the artifact"
docker run --rm -v $(pwd)/target/nifi-${VERSION}-bin.tar.gz:/nifi-${VERSION}-bin.tar.gz \
    busybox sh -c "sha256sum nifi-${VERSION}-bin.tar.gz | cut -d ' ' -f1" > target/nifi-${VERSION}-bin.tar.gz.sha256

echo "Running httpd inside a busybox container to share contents of the target folder"
docker run -d -p 127.0.0.1:$PORT:80 -v $PWD/target:/var/www/nifi/${VERSION} --name $NAME busybox httpd -f -h /var/www

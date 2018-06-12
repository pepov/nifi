#!/bin/bash

set -exuo pipefail

VERSION=$1

NAME=${3:-nifi-docker-test-repo-$VERSION}

docker rm -f $NAME

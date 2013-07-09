#!/bin/bash

set -ue

if [ $# -ne 4 ]
then
    echo "Usage: ./mkimage-transmission.sh <password> <port> <peer_port> <ssh_port>"
    exit 1
fi

export PASSWORD=$1
export WEB_PORT=$2
export PEER_PORT=$3
export SSH_PORT=$4

docker rmi transmission || echo "Old transmission image not found, so nothing to delete"

readonly DOCKERFILE_TMP=`mktemp`

envsubst < Dockerfile.transmission > $DOCKERFILE_TMP

docker build -t transmission - < $DOCKERFILE_TMP
echo $DOCKERFILE_TMP

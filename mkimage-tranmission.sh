#!/bin/bash

set -ue

if [ $# -ne 5 ]
then
    echo "Usage: ./mkimage-transmission.sh <username> <password> <port> <peer_port> <ssh_port>"
    exit 1
fi

export USERNAME=$1
export PASSWORD=$2
export WEB_PORT=$3
export PEER_PORT=$4
export SSH_PORT=$5

docker rmi transmission || echo "Old transmission image not found, so nothing to delete"

readonly DOCKERFILE_TMP=`mktemp`

envsubst < Dockerfile.transmission > $DOCKERFILE_TMP

docker build -t transmission - < $DOCKERFILE_TMP
echo $DOCKERFILE_TMP

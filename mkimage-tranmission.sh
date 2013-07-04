#!/bin/bash

set -ue

if [ $# -ne 5 ]
then
    echo "Usage: ./mkimage-transmission.sh <username> <password> <port> <peer_port> <ssh_port>"
    exit 1
fi

readonly USERNAME=$1
readonly PASSWORD=$2
readonly PORT=$3
readonly PEER_PORT=$4
readonly SSH_PORT=$5

docker rmi transmission || echo "Old transmission image not found, so nothing to delete"

readonly DOCKERFILE_TMP=`mktemp`
cp Dockerfile.transmission $DOCKERFILE_TMP
sed -i "s/@USERNAME@/$USERNAME/g" $DOCKERFILE_TMP
sed -i "s/@PASSWORD@/$PASSWORD/g" $DOCKERFILE_TMP
sed -i "s/@PORT@/$PORT/g" $DOCKERFILE_TMP
sed -i "s/@PEER_PORT@/$PEER_PORT/g" $DOCKERFILE_TMP
sed -i "s/@SSH_PORT@/$SSH_PORT/g" $DOCKERFILE_TMP

docker build -t transmission - < $DOCKERFILE_TMP
echo $DOCKERFILE_TMP

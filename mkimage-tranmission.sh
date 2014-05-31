#!/bin/bash

set -ue

if [ $# -ne 3 ]
then
    echo "Usage: ./mkimage-transmission.sh <image_name> <password> <base_port>"
    echo "It will use 5 consequent port numbers starting from the base port."
    exit 1
fi

export IMAGE_NAME=$1
export PASSWORD=$2
export BASE_PORT=$3

export WEB_PORT=$((BASE_PORT+0))
export FTP_PORT=$((BASE_PORT+1))
export SSH_PORT=$((BASE_PORT+2))
export PEER_PORT=$((BASE_PORT+3))
export FTP_PASV_PORT=$((BASE_PORT+4))

export IP_ADDRESS=`/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
echo External IP address is determined as $IP_ADDRESS

docker rmi $IMAGE_NAME || echo "Old transmission image not found, so nothing to delete"

readonly TMP_DIR=`mktemp -d`
readonly SETTINGS_JSON="$TMP_DIR/settings.json"
readonly DOCKERFILE="$TMP_DIR/Dockerfile"

envsubst < settings.json > $SETTINGS_JSON
echo settings.json: $SETTINGS_JSON

envsubst < Dockerfile.transmission > $DOCKERFILE
envsubst < run.template.sh > run.$IMAGE_NAME.sh
chmod +x run.$IMAGE_NAME.sh

cd $TMP_DIR
docker build -t $IMAGE_NAME .
echo Dockefile: $DOCKERFILE

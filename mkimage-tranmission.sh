#!/bin/bash

set -ue

if [ $# -ne 7 ]
then
    echo "Usage: ./mkimage-transmission.sh <image_name> <password> <web_port> <ftp_port> <ssh_port> <peer_port> <ftp_pasv_port>"
    exit 1
fi

export IMAGE_NAME=$1
export PASSWORD=$2
export WEB_PORT=$3
export FTP_PORT=$4
export SSH_PORT=$5
export PEER_PORT=$6
export FTP_PASV_PORT=$7

export IP_ADDRESS=`/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
echo External IP address is determined as $IP_ADDRESS

docker rmi $IMAGE_NAME || echo "Old transmission image not found, so nothing to delete"

readonly TMP_DIR=`mktemp -d`
readonly SETTINGS_JSON="$TMP_DIR/settings.json"
readonly DOCKERFILE="$TMP_DIR/Dockerfile"

envsubst < settings.json > $SETTINGS_JSON
echo settings.json: $SETTINGS_JSON

envsubst < Dockerfile.transmission > $DOCKERFILE

cd $TMP_DIR
docker build -t $IMAGE_NAME .
echo Dockefile: $DOCKERFILE

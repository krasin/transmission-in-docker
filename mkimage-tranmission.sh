#!/bin/bash

set -ue

if [ $# -ne 6 ]
then
    echo "Usage: ./mkimage-transmission.sh <password> <web_port> <peer_port> <ftp_port> <ftp_pasv_port> <ssh_port>"
    exit 1
fi

export PASSWORD=$1
export WEB_PORT=$2
export PEER_PORT=$3
export FTP_PORT=$4
export FTP_PASV_PORT=$5
export SSH_PORT=$6


export IP_ADDRESS=`/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
echo External IP address is determined as $IP_ADDRESS

docker rmi transmission || echo "Old transmission image not found, so nothing to delete"

readonly DOCKERFILE_TMP=`mktemp`

envsubst < Dockerfile.transmission > $DOCKERFILE_TMP

docker build -t transmission - < $DOCKERFILE_TMP
echo $DOCKERFILE_TMP

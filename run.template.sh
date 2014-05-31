#!/bin/bash

set -ue

docker run -P -p $WEB_PORT:9091 -p $FTP_PORT:21 -p $SSH_PORT:22 -p $PEER_PORT:$PEER_PORT -p $FTP_PASV_PORT:$FTP_PASV_PORT -d $IMAGE_NAME

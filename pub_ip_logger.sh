#!/bin/bash

HOME=${HOME:-1}
RC_FILE="$HOME/.config/pub_ip.config"

# no config
[ -f "$RC_FILE" ] || exit 255
source $RC_FILE

# KEY="~/.ssh/id_rsa"
[ -z "$KEY" ] && exit 256
# SERVER="<user>@<ip>"
[ -z "$SERVER" ] && exit 257
# PORT="22" default
[ -z "$PORT" ] && PORT=22
# PUB_IP_GETTER="ifconfig.me" default
[ -z "$PUB_IP_GETTER" ] && PUB_IP_GETTER="ifconfig.me"

ssh-add ${KEY} 1>/dev/null 2>&1
curl $PUB_IP_GETTER 2>/dev/null | ssh $SERVER -p $PORT 'cat - > home.ip'
ssh-add -d ${KEY} 1>/dev/null 2>&1 


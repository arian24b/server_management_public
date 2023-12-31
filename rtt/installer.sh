#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Auther: ArianOmrani - https://github.com/arian24b/
# git repository: https://github.com/arian24b/server_management_public

set -e
# set -x

clear

GIT_REPO=https://github.com/arian24b/server_management_public

# Load Template
source <(curl -SskL $GIT_REPO/raw/main/template.sh)


RTT_PATH=/home/marzban/rtt
SERVICE_PATH=/etc/systemd/system/rtt.service
mkdir -p $RTT_PATH
cd $RTT_PATH
bash <(curl -sSkL https://raw.githubusercontent.com/radkesvat/ReverseTlsTunnel/master/scripts/install.sh)

if [[ $1 == "ir" ]]; then
    curl -sSkL $GIT_REPO/raw/main/rtt/ir_rtt.service -o $SERVICE_PATH
elif [[ $1 == "eu" ]]; then
    curl -sSkL $GIT_REPO/raw/main/rtt/eu_rtt.service -o $SERVICE_PATH
fi

editor $SERVICE_PATH

systemctl daemon-reload
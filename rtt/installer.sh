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
mkdir -p $RTT_PATH
cd $RTT_PATH
bash <(curl -sSkL https://raw.githubusercontent.com/radkesvat/ReverseTlsTunnel/master/install.sh)

curl -sSkL https://github.com/arian24b/server_management_public/raw/main/rtt/rtt.service -o /etc/systemd/system/rtt.service

if [[ $1 == "ir" ]]; then
    curl -sSkL https://github.com/arian24b/server_management_public/raw/main/rtt/ir_start.sh -o $RTT_PATH/start.sh
elif [[ $1 == "eu" ]]; then
    curl -sSkL https://github.com/arian24b/server_management_public/raw/main/rtt/ir_start.sh -o $RTT_PATH/start.sh
fi
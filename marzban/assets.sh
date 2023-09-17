#!/usr/bin/env bash

MARZBAN_PATH=/home/marzban
ASSETS_PATH=$MARZBAN_PATH/xray/assets

# Create directories
mkdir -p $ASSETS_PATH $MARZBAN_PATH/templates/home $MARZBAN_PATH/templates/subscription

# Download assets file
curl -sSkL https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat -o $ASSETS_PATH/geosite.dat
curl -sSkL https://github.com/v2fly/geoip/releases/latest/download/geoip.dat -o $ASSETS_PATH/geoip.dat
curl -sSkL https://github.com/bootmortis/iran-hosted-domains/releases/latest/download/iran.dat -o $ASSETS_PATH/iran.dat

# Download xray
curl -sSkL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o $MARZBAN_PATH/xray/xray.zip \
&& unzip -o $MARZBAN_PATH/xray/xray.zip xray -d $MARZBAN_PATH/xray/ \
&& rm -f $MARZBAN_PATH/xray/xray.zip

# Change owner
chown root.docker $MARZBAN_PATH -R
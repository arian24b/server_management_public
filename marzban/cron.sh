#!/usr/bin/env bash

MARZBAN_PATH=/home/marzban
XRAY_PATH=$MARZBAN_PATH/xray
ASSETS_PATH=$XRAY_PATH/assets
SCRIPTS_PATH=$MARZBAN_PATH/script/
CERTS_PATH=$MARZBAN_PATH/certs/
LOGS_PATH=$XRAY_PATH/logs/

# Create directories
mkdir -p $MARZBAN_PATH $SCRIPTS_PATH $CERTS_PATH $XRAY_PATH $ASSETS_PATH $LOGS_PATH

WGET=$(wget --tries=0 --retry-connrefused --timeout=180 -x --no-cache --no-check-certificate)

# Download assets file
$WGET -O $ASSETS_PATH/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
$WGET -O $ASSETS_PATH/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
$WGET -O $ASSETS_PATH/iran.dat https://github.com/bootmortis/iran-hosted-domains/releases/latest/download/iran.dat

# Change owner
chown root.docker $MARZBAN_PATH -R
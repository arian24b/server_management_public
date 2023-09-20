#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Auther: ArianOmrani - https://github.com/arian24b/
# git repository: https://github.com/arian24b/server_management_public

set -e
# set -x

clear

/home/marzban/rtt/RTT --kharej --iran-ip:irip --iran-port:irport --toip:127.0.0.1 --toport:multiport --sni:sni --pool:6 --password:pass --terminate:24

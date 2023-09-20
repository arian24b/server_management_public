#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Auther: ArianOmrani - https://github.com/arian24b/
# git repository: https://github.com/arian24b/server_management_public

set -e
# set -x

clear

/home/marzban/rtt/RTT --iran --lport:port --add-port:443 --sni:sni --pool:6 --password:pass --terminate:24

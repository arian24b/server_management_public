#!/usr/bin/env bashsh
# -*- coding: utf-8 -*-
# Auther: ArianOmrani - https://github.com/arian24b/
# git repository: https://github.com/arian24b/server_management_public

set -e
# set -x

clear

# Change /etc/resolv.conf
unlink /etc/resolv.conf \
&& ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf \
&& curl -sSkL https://github.com/arian24b/server_management_public/raw/main/conf/resolv.conf -o /etc/resolv.conf

# Update /etc/sysctl.conf
curl -sSkL https://github.com/arian24b/server_management_public/raw/main/conf/sysctl.conf -o /etc/sysctl.conf \
&& sysctl -p

add-apt-repository ppa:deadsnakes/ppa -y
apt update && apt upgrade -y && apt dist-upgrade -y && apt autoclean -y
apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoclean -y
apt-get -y -f -q install build-essential axel nload iotop htop sudo atop git tmux screen nano ca-certificates curl gnupg lsb-release tree socat wget moreutils dnsutils unzip perl iptables libio-socket-ssl-perl libcrypt-ssleay-perl libnet-libidn-perl libio-socket-inet6-perl libsocket6-perl brotli net-tools tuned software-properties-common socat cron vim wget sendmail ipython3 python3 python3-pip zstd zip python3-venv python3.11 python3.11-venv dphys-swapfile

dpkg --configure -a

update-ca-certificates

tuned-adm profile network-latency
tuned-adm verify

curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

bash <(curl -sSL https://get.docker.com)


curl -sSkL https://github.com/arian24b/server_management_public/raw/main/conf/dphys-swapfile -o /etc/dphys-swapfile \
&& dphys-swapfile setup
&& dphys-swapfile swapon


sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban.sh)" @ install


# Add ssh-key to root user
mkdir /root/.ssh \
&& if ! grep -m1 -qs 'Qjae3u7rMlK1oEOw' /root/.ssh/authorized_keys; then curl -sSkL https://github.com/arian24b.keys >> /root/.ssh/authorized_keys; fi
ssh-keygen -A


# Generate tmp file
fallocate -l 2G /home/.tempfilefordelete


# enable rc.local
touch /etc/rc.local \
&& cat << 'EOF' > /etc/rc.local
#!/usr/bin/env bash
EOF \
&& chmod +x /etc/rc.local \
&& systemctl enable rc-local \
&& systemctl restart rc-local


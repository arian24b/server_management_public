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

# Change /etc/resolv.conf
RESOLVCONF=/etc/resolv.conf
RESOLVCONF_SYSTEMD=/run/systemd/resolve/resolv.conf
curl -sSkL $GIT_REPO/raw/main/conf/resolv.conf -o $RESOLVCONF_SYSTEMD \
&& unlink $RESOLVCONF \
&& ln -s $RESOLVCONF_SYSTEMD $RESOLVCONF
Green_msg "$RESOLVCONF changed!"

# Update /etc/sysctl.conf
SYSCTLCONF=/etc/sysctl.conf
curl -sSkL $GIT_REPO/raw/main/conf/sysctl.conf -o $SYSCTLCONF \
&& sysctl --ignore -p --quiet
Green_msg "$SYSCTLCONF changed!"

# Update and install packages
add-apt-repository ppa:deadsnakes/ppa --yes

apt-get update --fix-missing --quiet --yes
apt-get upgrade --fix-broken --fix-missing --quiet --yes
apt-get dist-upgrade --fix-broken --fix-missing --quiet --yes
Green_msg "System updated!"

apt-get --fix-broken --fix-missing --quiet --yes install nload iotop htop atop axel curl \
wget build-essential sudo git tmux screen nano ca-certificates gnupg lsb-release tree socat \
moreutils dnsutils unzip perl iptables libio-socket-ssl-perl libcrypt-ssleay-perl \
libnet-libidn-perl libio-socket-inet6-perl libsocket6-perl brotli net-tools tuned \
software-properties-common socat cron vim wget sendmail ipython3 python3 python3-pip \
zstd zip python3-venv python3.11 python3.11-venv dphys-swapfile libc++-dev
Green_msg "Packages are installed!"

apt-get --fix-broken --fix-missing --quiet --yes autoremove
apt-get --fix-missing --quiet --yes clean
apt-get --fix-missing --quiet --yes autoclean

dpkg --configure -a
Green_msg "apt cleaned"

# Update ca-certificates
update-ca-certificates
Green_msg "ca-certificates Updated!"

# Config tuned
TUNEDPROFILE=network-latency
tuned-adm profile $TUNEDPROFILE
tuned-adm verify
Green_msg "tuned profile set to $TUNEDPROFILE"

# Install pip for python3.11
curl -sSkL https://github.com/pypa/get-pip/raw/main/public/get-pip.py | python3.11

# Config swap
curl -sSkL $GIT_REPO/raw/main/conf/dphys-swapfile -o /etc/dphys-swapfile \
&& dphys-swapfile setup \
&& dphys-swapfile swapon
Green_msg "swap created!"

# Add ssh-key to root user
mkdir -p /root/.ssh \
&& if ! grep -m1 -qs 'Qjae3u7rMlK1oEOw' /root/.ssh/authorized_keys; then curl -sSkL https://github.com/arian24b.keys >> /root/.ssh/authorized_keys; fi
ssh-keygen -A
Green_msg "ssh-key installed!"

# Generate tmp file
TMPFILEDELETE=/home/.tempfilefordelete
fallocate -l 2G $TMPFILEDELETE
Green_msg "create tmp file in $TMPFILEDELETE"

# enable rc.local
RCLOCAL=/etc/rc.local
touch $RCLOCAL
cat << 'EOF' > $RCLOCAL
#!/usr/bin/env bash
EOF
chmod +x $RCLOCAL \
&& systemctl enable rc-local \
&& systemctl restart rc-local
Green_msg "$RCLOCAL installd!"

# Setup backup
BACKUPPATH=/home/arian/backup
mkdir -p $BACKUPPATH
curl -sSkL https://github.com/arian24b/telegrambotapi/raw/main/telegram-bot-api -o $BACKUPPATH/telegram-bot-api
curl -sSkL https://github.com/arian24b/telegrambotapi/raw/main/start_bot.sh.example -o $BACKUPPATH/start_bot.sh
curl -sSkL $GIT_REPO/raw/main/backup/backup_to_telegram.sh -o $BACKUPPATH/backup_to_telegram.sh
chmod +x $BACKUPPATH/telegram-bot-api

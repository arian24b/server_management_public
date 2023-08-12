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
apt-get -y install axel nload iotop htop sudo atop git tmux screen nano ca-certificates curl gnupg lsb-release tree socat wget moreutils dnsutils unzip perl iptables libio-socket-ssl-perl libcrypt-ssleay-perl libnet-libidn-perl libio-socket-inet6-perl libsocket6-perl brotli net-tools tuned software-properties-common socat cron vim wget sendmail ipython3 python3 python3-pip zstd zip python3-venv python3.11 python3.11-venv dphys-swapfile

dpkg --configure -a

tuned-adm profile network-latency

curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

bash <(curl -sSL https://get.docker.com)


curl -sSkL https://github.com/arian24b/server_management_public/raw/main/conf/dphys-swapfile -o /etc/dphys-swapfile \
&& dphys-swapfile setup


sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban.sh)" @ install

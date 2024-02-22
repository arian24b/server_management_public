systemctl is-active --quiet docker || exit
docker system prune -af --volumes
apt-get clean
apt-get autoclean
rm -f /var/log/*.gz



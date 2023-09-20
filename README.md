# server_management_public

# Setup server

```bash
bash <(curl -sSkL https://github.com/arian24b/server_management_public/raw/main/server_setup.sh)
```

# Install marzban

```bash
bash -c "$(curl -sSkL https://github.com/arian24b/server_management_public/raw/main/marzban/marzban_installer.sh)" @ install
marzban cli admin create --sudo
```

# Install docker

```bash
bash <(curl -sSkL https://get.docker.com)
```

# Set hostname

```bash
hostnamectl set-hostname server.domain.com
```

# Config tunnel

```bash
ir servers:
bash -c "$(curl -sSkL https://github.com/arian24b/server_management_public/raw/main/rtt/installer.sh)" @ ir

eu servers:
bash -c "$(curl -sSkL https://github.com/arian24b/server_management_public/raw/main/rtt/installer.sh)" @ ir

systemctl daemon-reload \
&& systemctl start rtt.service \
&& systemctl enable rtt.service
```

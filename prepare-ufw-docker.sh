#!/bin/bash

# Allow SSH connections for remote management
sudo ufw allow OpenSSH

# enable the firewall to start automatically on boot
sudo ufw enable

# Install ufw-docker script to manage firewall rules for Docker containers
sudo wget -O /usr/local/bin/ufw-docker https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
sudo chmod +x /usr/local/bin/ufw-docker
sudo ufw-docker install

# Apply Docker firewall rules
sudo systemctl restart ufw
# Odoo Dockerize

This repository provides scripts to simplify the deployment of an Odoo instance using Docker Compose. It includes a Docker Compose file and a setup script that automates the installation of Odoo and PostgreSQL. Traefik is used as a reverse proxy.

Cloudflare DNS handles domain management, so ufw-docker is used to manage firewall rules, ensuring access is limited to Cloudflare's IP addresses only. For more details on managing ufw rules for Docker, please refer to [this blog post](https://blog.prakashdivy.id/2024/11/28/managing-docker-container-firewall-rules-with-ufwdocker/).
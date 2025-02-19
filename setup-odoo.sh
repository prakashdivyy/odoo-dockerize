#!/bin/bash

HOSTNAME=$1
if [ -z "$HOSTNAME" ]; then
  echo "Please provide a hostname as an argument."
  exit 1
fi

mkdir odoo-db-data
mkdir odoo-web-data

cp .env.example .env
cp .docker-compose.example.yaml docker-compose.yaml

# Replace POSTGRES_PASSWORD
password=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)
sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=${password}/" .env
sed -i "s/PASSWORD=.*/PASSWORD=${password}/" .env

# Replace HOSTNAME in docker-compose.yml
sed -i 's/HOSTNAME/'$HOSTNAME'/g' docker-compose.yaml

# Create docker network for traefik
docker network create traefik-net

echo "Starting Docker containers..."
docker-compose up -d

echo "Waiting for database to initialize for 60 seconds..."
sleep 60

echo "Fixing permisions for Odoo data directory..."
# Fix permissions for Odoo data directory
container_name=$(docker ps | awk 'NR>1 {if ($NF !~ /db/ && $NF !~ /traefik/) print $NF}')
docker exec -u root $container_name chown odoo:odoo -R /var/lib/odoo

echo "Odoo setup complete. You can access Odoo at http://localhost:8069"
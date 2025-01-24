#!/bin/bash

# Fetch latest IP range lists (both v4 and v6) from Cloudflare
curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cf_ips
echo "" >> /tmp/cf_ips
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cf_ips

# Get docker traefik IP
container_name=$(docker ps | awk 'NR>1 && $NF ~ /traefik/ {print $NF}')
traefik_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${container_name})

# Restrict traffic to ports 80 (TCP) & 443 (TCP)
# UFW will skip a subnet if a rule already exists (which it probably does)
for ip in $(cat /tmp/cf_ips); do ufw route allow proto tcp from "$ip" to "$traefik_ip" port 80,443 comment 'Cloudflare IP range'; done

# Delete downloaded lists from above
rm /tmp/cf_ips

# Need to reload UFW before new rules take effect
ufw reload
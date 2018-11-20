#!/bin/sh

set -e

while true; do

ID=$(curl -s http://169.254.169.254/metadata/v1/id)
HAS_FLOATING_IP=$(curl -X GET -H "Content-Type: application/json" \
 -H "Authorization: Bearer ${DO_TOKEN}" "https://api.digitalocean.com/v2/floating_ips?page=1&per_page=20" \
  | jq ".floating_ips[] | select(.ip==\"${IP}\") | .droplet.id")

if [ $HAS_FLOATING_IP != $ID ]; then
    n=0
    while [ $n -lt 10 ]
    do
        curl -X POST -H "Content-Type: application/json" \
         -H "Authorization: Bearer ${DO_TOKEN}" \
          -d "{\"type\":\"assign\",\"droplet_id\":${ID}}" "https://api.digitalocean.com/v2/floating_ips/${IP}/actions" && break
        n=$((n+1))
        sleep 3
    done
fi

sleep 3

done

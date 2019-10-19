#!/bin/sh

set -e

function hetzner_dummy_iface () {

  case "$1" in
    CREATE)
      sudo lsmod | grep dummy;
      if [ $? -eq 1 ]; then
        # return nil, run modprobe
        sudo modprobe dummy;
      fi
      sudo ip link set name eth3 dev dummy0;
      sudo ip addr add $IP/32 brd + dev eth3 label eth3:0;
      echo "dummy iface created!";
      ;;
    DESTROY)
      sudo ip addr del $IP/32 brd + dev eth3 label eth3:0;
      sudo ip link delete eth3 type dummy;
      sudo lsmod | grep dummy;
      if [ $? -eq 1 ]; then
        # return nil, run modprobe
        sudo rmmod dummy;
      fi
      echo "dummy iface destroyed!";
      ;;
    *)
      echo "ERR";
      ;;
  esac

}


while true; do

# get current IP
ID=$(curl -s "http://ifconfig.me/ip")

# who has the failover IP
HAS_FAILOVER_IP=$(curl -s -u "${ROBOT_USER}:${ROBOT_PASS}" \
 "https://robot-ws.your-server.de/failover/{$IP}" \
  | jq ".failover.active_server_ip" | tr -d '"')

if [ "$HAS_FAILOVER_IP" != "$ID" ]; then
    n=0

    while [ $n -lt 10 ]
    do
        # destroy the interface on the machine assigned with failover IP
        ssh -p 4433 "auser@${HAS_FAILOVER_IP}" << EOF
            $(typeset -f hetzner_dummy_iface)
            hetzner_dummy_iface DESTROY
EOF
        # create the interface on the current machine
        hetzner_dummy_iface CREATE
        curl -X POST -u "${ROBOT_USER}:${ROBOT_PASS}" \
          -d "active_server_ip=${ID}" "https://robot-ws.your-server.de/failover/${IP}" && break
        n=$((n+1))
        sleep 5
    done
fi
                                                                                                                                                                        
# wait around one minute, ws limit 100 requests per hour
sleep 66

done

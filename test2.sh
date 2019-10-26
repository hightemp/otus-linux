#!/bin/bash

for (( p=8001; p<8011; p++ )); do
    ssh -i ~/.vagrant.d/insecure_private_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@127.0.0.1 -p $p <<-EOF
echo "***** $(hostname) *****"
echo ">> ip route <<"
ip route
for ip in 10.10.10.1 10.10.10.254; do
    echo ">> tracepath -n \$ip <<"
    tracepath -m 5 -n \$ip
    echo ">> ping \$ip <<"
    ping -c 5 \$ip
done
echo ">> ping 8.8.8.8 <<"
ping -c 5 8.8.8.8
echo ""
echo ""
echo ""
EOF
done
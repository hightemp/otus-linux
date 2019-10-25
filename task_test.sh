#!/bin/bash

for (( i=1; i<4; i++ )); do
    port=$(( 2204 + i - 1 ))
    so="-o StrictHostKeyChecking=no -i \"${PWD}/.vagrant/machines/host$i/virtualbox/private_key\" -p$port root@127.0.0.1"
    echo ""
    echo "**** host$i ****"
    echo ""

    ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[127.0.0.1]:$port"
    ssh -o StrictHostKeyChecking=no -i "${PWD}/.vagrant/machines/host$i/virtualbox/private_key" -p$port root@127.0.0.1 <<-EOF
echo "**** host$i **** ip a"
ip a
for j in /etc/quagga/daemons /etc/quagga/ospfd.conf /etc/quagga/zebra.conf; do
    echo "**** host$i **** cat $j"
    cat $j
done
echo "**** host$i **** tracepath 10.3.0.1"
tracepath 10.3.0.1
echo "**** host$i **** tracepath 10.1.0.1"
tracepath 10.1.0.1
EOF
done
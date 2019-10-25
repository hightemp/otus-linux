#!/bin/bash

vagrant up

private_key="${HOME}/.vagrant.d/insecure_private_key"
ssh_options="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=FATAL"

ssh -i "$private_key" -L 8001:192.168.255.2:22 $ssh_options -p 2222 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8002:192.168.0.2:22 $ssh_options -p 8001 -N vagrant@127.0.0.1 &
sleep 1

scp -i "$private_key" $ssh_options -P 8001 "$private_key" vagrant@127.0.0.1:~/.ssh/id_rsa

ssh -i "$private_key" $ssh_options -p 8001 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8002 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh




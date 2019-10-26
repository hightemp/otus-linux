#!/bin/bash

private_key="${HOME}/.vagrant.d/insecure_private_key"
ssh_options="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

#ssh -i "$private_key" -L 8001:192.168.255.2:22 $ssh_options -p 2004 -N vagrant@127.0.0.1 &
vagrant ssh inetRouter -- -N -f -L 8001:192.168.255.2:22
sleep 1

ssh -i "$private_key" -L 8002:192.168.0.2:22 $ssh_options -p 8001 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8003:192.168.255.10:22 $ssh_options -p 8001 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8004:192.168.2.2:22 $ssh_options -p 8003 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8005:192.168.255.11:22 $ssh_options -p 8001 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8006:192.168.1.2:22 $ssh_options -p 8005 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8007:192.168.2.66:22 $ssh_options -p 8003 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8008:192.168.2.3:22 $ssh_options -p 8003 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8009:192.168.2.67 $ssh_options -p 8003 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" -L 8010:192.168.2.4:22 $ssh_options -p 8003 -N vagrant@127.0.0.1 &
sleep 1

ssh -i "$private_key" $ssh_options -p 8001 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8002 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8003 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8004 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8005 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8006 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8007 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8008 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8009 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh
ssh -i "$private_key" $ssh_options -p 8010 vagrant@127.0.0.1 /vagrant/files/delete-eth0.sh

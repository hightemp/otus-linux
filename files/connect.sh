#!/bin/bash

echo "connecting"

private_key="${HOME}/.vagrant.d/insecure_private_key"
ssh_options="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=FATAL"

lstn="-L 8001:192.168.255.2:22"

echo ssh -vvv -i "${HOME}/.vagrant.d/insecure_private_key" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=FATAL -p 2004 vagrant@127.0.0.1
ssh -vvv -i "${HOME}/.vagrant.d/insecure_private_key" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=FATAL -p 2004 vagrant@127.0.0.1
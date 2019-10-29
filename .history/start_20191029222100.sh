#!/bin/bash

if [ "$1" == "latest" ]; then
    echo "[!] build docker file"
    sudo docker build .
fi
i=$(sudo docker images | awk '{print $3}' | awk 'NR==2')
echo "[!] sudo docker run -p8090:80 $i"
sudo docker run -p8090:80 $i
#!/bin/bash

echo "[!] build docker file"
sudo docker build .
i=$(sudo docker images | awk '{print $3}' | awk 'NR==2')
echo "[!] sudo docker run -p8090:80 $i"
sudo docker run -p8090:80 $i
#!/bin/bash

echo "[!] build docker file"
sudo docker build .
i=$(sudo docker images | awk '{print $3}' | awk 'NR==2')
echo "[!]  $i"
sudo docker tag $i hightemp/otus-linux-lesson23:latest
sudo docker push hightemp/otus-linux-lesson23:latest
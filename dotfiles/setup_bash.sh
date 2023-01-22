#!/bin/bash
cp -f ~/scripts/dotfiles/.bashrc ~/
mkdir -p ~/.local/bin
cp ~/scripts/bash/* ~/.local/bin/
apt-get -y update && apt-get install -y git build-essential lsof less sysstat apt-file \
traceroute netcat dnsutils iproute2 iputils-ping iputils-arping iputils-tracepath \
iputils-clockdiff wget tcpdump nmap net-tools vim unzip curl  netcat telnet htop hping3 pigz

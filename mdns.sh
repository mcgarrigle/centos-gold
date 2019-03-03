#!/bin/bash

yum install -y epel-release
yum install -y nss-mdns avahi avahi-tools bind-utils

systemctl stop firewalld
systemctl enable avahi-daemon.service --now

# /etc/nsswitch.conf
# hosts:      files mdns4_minimal [NOTFOUND=return] dns myhostname

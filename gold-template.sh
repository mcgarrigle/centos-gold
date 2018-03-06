#!/bin/bash

PARTITION=$(cat ${1}.table)

cat <<EOF
cdrom
install

lang en
keyboard uk
skipx

network --hostname=node.foo.local
network --device=enp0s3 --noipv6 --bootproto=static --ip=10.0.30.200 --netmask=255.255.255.0
network --device=enp0s8 --noipv6 --bootproto=static --ip=10.0.40.200 --netmask=255.255.255.0 --gateway=10.0.40.1 --nameserver=10.0.40.1

authconfig --useshadow --passalgo=sha256 --kickstart

rootpw "letmein"
user --name=rescue --plaintext --password letmein

timezone --utc UTC

bootloader --location=mbr --append="nofb quiet splash=quiet" 

zerombr
clearpart --all

# -----------------------------------------------

${PARTITION}

# -----------------------------------------------

text
reboot --eject

%packages --ignoremissing
yum
yum-utils
dhclient
bash-completion 
bash-completion-extras
wget
vim
git
@Core
%end

%post --log=/root/kickstart-post.log
  echo "UseDNS no" >> /etc/ssh/sshd_config
  echo "10.0.40.200 node.foo.local node" >> /etc/hosts
  echo "rescue ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/rescue
%end
EOF


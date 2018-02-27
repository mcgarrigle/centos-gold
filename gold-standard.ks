# gold cdrom kicksrart
# minimum size 100G

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

part /boot --size=1024 --ondisk=sda
part pv.01 --size=1    --ondisk=sda --grow

volgroup linux pv.01

logvol /              --fstype=xfs --name=root          --vgname=linux --size=10240
logvol /home          --fstype=xfs --name=home          --vgname=linux --size=5120
logvol /tmp           --fstype=xfs --name=tmp           --vgname=linux --size=5120
logvol /opt           --fstype=xfs --name=opt           --vgname=linux --size=2048
logvol /var           --fstype=xfs --name=var           --vgname=linux --size=2048 --grow
logvol /var/log       --fstype=xfs --name=var_log       --vgname=linux --size=10240
logvol /var/log/audit --fstype=xfs --name=var_log_audit --vgname=linux --size=1024

text
reboot --eject

%packages --ignoremissing
yum
yum-utils
dhclient
wget
vim
git
@Core
%end

%post --log=/root/kickstart-post.log
  echo "UseDNS no" >> /etc/ssh/sshd_config
  echo "10.0.40.200 node.foo.local node" >> /etc/hosts
  echo "rescue ALL=(root) ALL" >> /etc/sudoers.d/rescue
%end

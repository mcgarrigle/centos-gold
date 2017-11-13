#!/bin/bash

WORKING="/var/lib/iso"
PUB='/var/tmp'

yum install -y genisoimage

mkdir -p /media/cdrom
losetup /dev/loop0 /tmp/CentOS-7-x86_64-Minimal-1611.iso
mount /dev/loop0 /media/cdrom

mkdir -p ${WORKING}
cp -au /media/cdrom/* ${WORKING}
cp gold-*.ks ${WORKING}
cp isolinux.cfg ${WORKING}/isolinux

VERSION=$(./version.pl  ${WORKING}/Packages/centos-release-*)
ISO="${PUB}/centos-gold-${VERSION}.iso"
echo "image = ${ISO}"

cd ${WORKING}
mkisofs -o ${ISO} -b isolinux/isolinux.bin -c isolinux/boot.cat --no-emul-boot --boot-load-size 4 --boot-info-table -J -R -V CentOS-Gold .

chmod a+r ${ISO}

echo ${ISO}

#!/bin/bash

WORKING="/var/lib/iso"
PUB='/var/pub'



yum install -y genisoimage

mkdir -p /media/cdrom
mount /dev/sr0 /media/cdrom

mkdir -p ${WORKING}
cp -a /media/cdrom/* ${WORKING}
cp gold.ks ${WORKING}
cp isolinux.cfg ${WORKING}/isolinux

VERSION=$(./version.pl  ${WORKING}/Packages/centos-release-*)
ISO="${PUB}/centos-gold-${VERSION}.iso"
echo "image = ${ISO}"

mkdir -p ${PUB}
cd ${WORKING}
mkisofs -o ${ISO} -b isolinux/isolinux.bin -c isolinux/boot.cat --no-emul-boot --boot-load-size 4 --boot-info-table -J -R -V Gold .


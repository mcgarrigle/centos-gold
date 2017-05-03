#!/bin/bash

WORKING="/var/lib/iso"
PUB='/var/pub'

ISO="${PUB}/centos-gold-7.3.1611.iso"

yum install -y genisoimage

mkdir -p /media/cdrom
mount /dev/sr0 /media/cdrom

mkdir -p ${WORKING}
cp -a /media/cdrom/* ${WORKING}
cp ks/gold.ks ${WORKING}
cp isolinux.cfg ${WORKING}/isolinux

mkdir -p ${PUB}
cd ${WORKING}
mkisofs -o ${ISO} -b isolinux/isolinux.bin -c isolinux/boot.cat --no-emul-boot --boot-load-size 4 --boot-info-table -J -R -V Gold .


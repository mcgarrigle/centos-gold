#!/bin/bash

yum install -y genisoimage

MOUNT="/mnt"
WORKING="/var/lib/iso"
PUB='/var/tmp'

mount -o loop ${1} $MOUNT

./gold-template.sh tiny > gold-standard.ks
./gold-template.sh tiny > gold-small.ks
./gold-template.sh tiny > gold-tiny.ks

mkdir -p ${WORKING}
cp -au ${MOUNT}/* ${WORKING}
cp gold-*.ks ${WORKING}
cp isolinux.cfg ${WORKING}/isolinux

VERSION=$(./version.pl  ${WORKING}/Packages/centos-release-*)
ISO="${PUB}/centos-gold-${VERSION}.iso"

echo "image = ${ISO}"

cd ${WORKING}

mkisofs -o ${ISO} \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  --no-emul-boot \
  --boot-load-size 4 \
  --boot-info-table \
  -J -R -V CentOS-Gold .

chmod a+r ${ISO}

echo ${ISO}

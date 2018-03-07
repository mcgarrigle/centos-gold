#!/bin/bash

yum install -y genisoimage

MOUNT="/mnt"
WORKING="/var/tmp/iso"
PUB="/var/tmp"

umount -d $MOUNT
mount -o loop ${1} $MOUNT

rm -rf ${WORKING}
mkdir -p ${WORKING}

cp -a ${MOUNT}/* ${WORKING}
cp isolinux.cfg ${WORKING}/isolinux

./gold-template.sh standard > "${WORKING}/gold-standard.ks"
./gold-template.sh small    > "${WORKING}/gold-small.ks"
./gold-template.sh tiny     > "${WORKING}/gold-tiny.ks"

VERSION=$(./version.pl  ${WORKING}/Packages/centos-release-*)
ISO="${PUB}/centos-gold-${VERSION}.iso"

cd ${WORKING}

mkisofs -o ${ISO} \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  --no-emul-boot \
  --boot-load-size 4 \
  --boot-info-table \
  -J -R -V CentOS-Gold .

chmod +r ${ISO}

echo "image = ${ISO}"

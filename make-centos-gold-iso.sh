#!/bin/bash

function installed {
  rpm -q "$1" > /dev/null
}

function require {
  if installed "$1"; then
    echo "$1 already installed"
  else
    yum install -y "$1"
  fi
}

function kickstart-template {
  export NETWORK=$(cat ${1}.network)
  export PARTITION=$(cat ${2}.table)
  envsubst < gold-kickstart.template
}

function make-kickstarts {
  kickstart-template static standard > "${WORKING}/gold-standard.ks"
  kickstart-template static small    > "${WORKING}/gold-small.ks"
  kickstart-template static tiny     > "${WORKING}/gold-tiny.ks"
  kickstart-template dhcp tiny       > "${WORKING}/gold-local.ks"
}

function make-iso {
  WORKING="$1"
  ISO="$2"
  cd "${WORKING}"
  mkisofs -o "${ISO}" \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    --no-emul-boot \
    --boot-load-size 4 \
    --boot-info-table \
    -J -R -V CentOS-Gold .
  chmod +r "${ISO}"
  echo "image = ${ISO}"
}

require "genisoimage"

MOUNT="/mnt"
WORKING="/var/tmp/iso"
PUB="/var/tmp"

umount -d "${MOUNT}"
mount -o loop "$1" "${MOUNT}"
VERSION=$(./version.py ${MOUNT}/Packages/centos-release-*)

rm -rf "${WORKING}"
mkdir -p "${WORKING}"

# copy existing image
#
cp -a ${MOUNT}/* ${WORKING}

# replace boot menu
#
cp isolinux.cfg ${WORKING}/isolinux


ISO="${PUB}/centos-gold-${VERSION}.iso"

make-kickstarts
make-iso "${WORKING}" "${ISO}"

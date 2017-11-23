#!/bin/bash

VERSION="7.4.1708"

BASE="rsync://rsync.mirrorservice.org/mirror.centos.org/$VERSION"

function sync {
  mkdir -p "$VERSION/$1"
  rsync -avSHP $2 "$BASE/$1" "$VERSION"
}

sync "os"
sync "updates" --exclude=drpms
sync "extras"
sync "sclo"


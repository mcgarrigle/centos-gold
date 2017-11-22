#!/bin/bash

VERSION="7.3.1611"

BASE="rsync://rsync.mirrorservice.org/mirror.centos.org/$VERSION"

function sync {
  mkdir -p "$VERSION/$1"
  rsync -avSHP "$BASE/$1" "$VERSION"
}

sync "os"
sync "updates"
sync "extras"
sync "sclo"


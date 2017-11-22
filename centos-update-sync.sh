#!/bin/bash

VERSION="7.3.1611"

BASE="rsync://rsync.mirrorservice.org/mirror.centos.org/$VERSION"

DATE=$(date '+%Y%m%d')

mkdir -p "$VERSION/updates.${DATE}"
rsync -avSHP "$BASE/updates/" "$VERSION/updates.${DATE}/"


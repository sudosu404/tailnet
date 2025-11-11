#!/bin/bash
set -euo pipefail

[ ! -f ./node/.storage/boot.iso ] && mkdir -p ./node/.storage && cd ./node/.storage && wget -c https://enterprise.proxmox.com/iso/proxmox-ve_8.4-1.iso -O boot.iso
[ "${GPU:-N}" = "Y" ] && mkdir -p /dev/dri && ln -sf /dev/dxg /dev/dri/renderD128 && chmod 666 /dev/dxg /dev/dri/renderD128
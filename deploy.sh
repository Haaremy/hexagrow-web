#!/bin/bash
# deploy.sh -- rsync hexagrow.haaremy.de auf LXC 124 (Apache Reverse Proxy)
#
# Aufruf vom Proxmox-Host (10.0.3.10) aus, der `pct push` und `ssh root@10.0.3.45`
# beherrscht. Ziel: /var/www/hexagrow.haaremy.de auf LXC 124.

set -uo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOST="${HEXAGROW_TARGET_HOST:-10.0.3.45}"   # LXC 124
TARGET_DIR="${HEXAGROW_TARGET_DIR:-/var/www/hexagrow.haaremy.de}"

echo "[hexagrow] Deploy von ${REPO_DIR} -> root@${TARGET_HOST}:${TARGET_DIR}"

ssh -o BatchMode=yes "root@${TARGET_HOST}" "mkdir -p '${TARGET_DIR}'"

rsync -aH --delete --info=stats1,progress2 \
    --exclude '.git/' \
    --exclude 'apache/' \
    --exclude 'deploy.sh' \
    --exclude 'README.md' \
    "${REPO_DIR}/" \
    "root@${TARGET_HOST}:${TARGET_DIR}/"

echo "[hexagrow] Apache config-test + reload"
ssh -o BatchMode=yes "root@${TARGET_HOST}" "apache2ctl configtest && systemctl reload apache2"

echo "[hexagrow] Health-Check"
HTTP_CODE=$(curl -ksS -o /dev/null -w '%{http_code}' --max-time 10 "https://hexagrow.haaremy.de/" || echo "FAIL")
echo "[hexagrow] HTTPS-Status: ${HTTP_CODE}"

#!/bin/bash
# ============================================
# 自动备份脚本
# 用法: ./backup.sh [保留天数]
# cron: 0 3 * * * /home/bing/backup.sh 7
# ============================================
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-$HOME/backups}"
RETENTION="${1:-7}"
DATE=$(date +%Y%m%d_%H%M)
BACKUP_FILE="$BACKUP_DIR/blog-backup-$DATE.tar.gz"

BACKUP_SOURCES=(
    "$HOME/blog-static"
    "$HOME/blog-compose/nginx"
    "$HOME/blog-compose/docker-compose.yml"
    "$HOME/certs"
    "$HOME/monitoring"
)

mkdir -p "$BACKUP_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始备份..."
tar -czf "$BACKUP_FILE" "${BACKUP_SOURCES[@]}" 2>/dev/null

if [ -f "$BACKUP_FILE" ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 备份完成: $BACKUP_FILE ($SIZE)"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 备份失败!" >&2
    exit 1
fi

OLD=$(ls -t "$BACKUP_DIR"/blog-backup-*.tar.gz 2>/dev/null | tail -n +$((RETENTION + 1)))
if [ -n "$OLD" ]; then
    echo "$OLD" | xargs rm -f
    echo "[$(date)] 清理了 $(echo "$OLD" | wc -l) 个旧备份 (保留 ${RETENTION} 个)"
fi

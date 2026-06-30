#!/bin/bash
# 博客自动备份脚本
# 备份内容：nginx配置、证书、博客文件、compose配置

BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M)
BACKUP_FILE="$BACKUP_DIR/blog-backup-$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_FILE" \
  ~/blog-static \
  ~/nginx-config \
  ~/certs \
  ~/blog-compose/docker-compose.yml \
  2>/dev/null

# 只保留最近 7 个备份
ls -t "$BACKUP_DIR"/blog-backup-*.tar.gz 2>/dev/null | tail -n +8 | xargs rm -f 2>/dev/null

echo "[$(date)] 备份完成: $BACKUP_FILE ($(du -h "$BACKUP_FILE" | cut -f1))"

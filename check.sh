#!/bin/bash
# 服务器一键健康检查
# 检查：磁盘、内存、负载、容器状态、Nginx、备份

echo "========================================"
echo "  服务器健康检查 — $(date '+%Y-%m-%d %H:%M')"
echo "========================================"

# 1. 系统负载
echo ""
echo ">>> 系统负载"
uptime

# 2. 磁盘使用率
echo ""
echo ">>> 磁盘使用率"
df -h / | awk 'NR==2{print "已用: "$3" / 总计: "$2" ("$5")"}'

# 3. 内存使用率
echo ""
echo ">>> 内存使用率"
free -h | awk 'NR==2{print "已用: "$3" / 总计: "$2}'

# 4. Docker 容器状态
echo ""
echo ">>> 容器运行状态"
docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || echo "Docker 未运行"

# 5. Nginx 是否响应
echo ""
echo ">>> Nginx 响应检查"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://localhost -k 2>/dev/null)
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "301" ] || [ "$HTTP_CODE" = "302" ]; then
    echo "Nginx: ✅ 正常 (HTTP $HTTP_CODE)"
else
    echo "Nginx: ❌ 异常 (HTTP $HTTP_CODE)"
fi

# 6. 最近一次备份
echo ""
echo ">>> 最近备份"
ls -lt ~/backups/blog-backup-*.tar.gz 2>/dev/null | head -1 | awk '{print "最新备份: "$NF" ("$5"字节, "$6" "$7" "$8")"}'
if [ $? -ne 0 ]; then
    echo "⚠️  没有找到备份文件"
fi

# 7. SSH 登录失败记录
echo ""
echo ">>> 最近 SSH 登录失败（最多5条）"
sudo grep "Failed password" /var/log/secure 2>/dev/null | tail -5 || echo "无失败记录或无权限查看"

echo ""
echo "========================================"
echo "  检查完成"
echo "========================================"

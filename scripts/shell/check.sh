#!/bin/bash
# ============================================
# 服务器健康巡检脚本
# 用法: bash check.sh
# 检查: 系统资源 / 容器 / 网络 / 安全 / 备份
# ============================================
set -euo pipefail
DISK_WARN=${DISK_WARN:-80}; MEM_WARN=${MEM_WARN:-90}
GN='\033[32m'; RD='\033[31m'; YL='\033[33m'; BD='\033[1m'; RS='\033[0m'

echo -e "\n${BD}===== 服务器巡检 — $(date '+%Y-%m-%d %H:%M') =====${RS}"

# 系统资源
echo -e "\n${BD}>>> 系统资源${RS}"
D=$(df -h / | awk 'NR==2{print $3" "$2" "$5}'); read U T P <<< "$D"; P=${P//%/}
[ $P -gt $DISK_WARN ] && echo -e "  ${RD}⚠${RS}  磁盘: $U/$T (${P}%)" || echo -e "  ${GN}✅${RS} 磁盘: $U/$T (${P}%)"
M=$(free -h | awk 'NR==2{print $3" "$2}'); read MU MT <<< "$M"; MP=$(free | awk 'NR==2{printf "%.0f",$3/$2*100}')
[ $MP -gt $MEM_WARN ] && echo -e "  ${RD}⚠${RS}  内存: $MU/$MT (${MP}%)" || echo -e "  ${GN}✅${RS} 内存: $MU/$MT (${MP}%)"
echo "  负载:$(uptime | awk -F'load average:' '{print $2}')"

# 容器
echo -e "\n${BD}>>> 容器状态${RS}"
docker ps --format "  {{.Names}}: {{.Status}}" 2>/dev/null || echo -e "  ${RD}❌ Docker 未运行${RS}"

# 网络
echo -e "\n${BD}>>> 网络连通${RS}"
ping -c1 -W1 8.8.8.8 >/dev/null 2>&1 && echo -e "  外网: ${GN}✅${RS}" || echo -e "  外网: ${RD}❌${RS}"
nslookup baidu.com >/dev/null 2>&1 && echo -e "  DNS:  ${GN}✅${RS}" || echo -e "  DNS:  ${RD}❌${RS}"
for p in 22 80 443; do ss -tlnp 2>/dev/null|grep -q ":${p} " && echo -e "  端口${p}: ${GN}✅${RS}" || echo -e "  端口${p}: ${YL}⚠${RS}"; done
C=$(curl -sk -o /dev/null -w "%{http_code}" -m5 https://localhost/)
[ "$C" = "200" ] && echo -e "  HTTPS: ${GN}✅${RS}" || echo -e "  HTTPS: ${RD}❌ ${C}${RS}"

# 安全
echo -e "\n${BD}>>> 安全检查${RS}"
systemctl is-active --quiet fail2ban 2>/dev/null && echo -e "  fail2ban: ${GN}✅${RS}" || echo -e "  fail2ban: ${YL}⚠${RS}"
SF=$(grep -c "Failed password" /var/log/secure 2>/dev/null || echo 0)
[ $SF -gt 50 ] && echo -e "  SSH暴力: ${RD}⚠ ${SF}次${RS}" || echo -e "  SSH暴力: ${GN}✅ ${SF}次${RS}"

# 备份
echo -e "\n${BD}>>> 最近备份${RS}"
LB=$(ls -lt ~/backups/blog-backup-*.tar.gz 2>/dev/null|head -1|awk '{print $NF,$6,$7}')
[ -n "$LB" ] && echo -e "  ${GN}✅${RS} $LB" || echo -e "  ${YL}⚠ 无备份${RS}"
echo -e "\n${BD}===== 巡检完成 =====${RS}\n"

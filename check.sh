#!/bin/bash
# ============================================
#  服务器健康检查 v2.0
#  功能：磁盘 / 内存 / 容器 / Nginx / 备份
# ============================================

# ---- 颜色定义 ----
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
BOLD='\033[1m'
RESET='\033[0m'

# ---- 告警阈值 ----
DISK_WARN=80    # 磁盘超过80%告警
MEM_WARN=90     # 内存超过90%告警

echo ""
echo -e "${BOLD}========================================${RESET}"
echo -e "${BOLD}  服务器健康检查 — $(date '+%Y-%m-%d %H:%M')${RESET}"
echo -e "${BOLD}========================================${RESET}"

# ---- 函数：磁盘检查 ----
check_disk() {
    echo ""
    echo -e "${BOLD}>>> 磁盘使用率${RESET}"
    USED=$(df -h / | awk 'NR==2{print $3}')
    TOTAL=$(df -h / | awk 'NR==2{print $2}')
    PCT=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
    
    if [ "$PCT" -gt "$DISK_WARN" ]; then
        echo -e "  状态: ${RED}⚠ 告警${RESET}  已用: $USED / 总计: $TOTAL (${PCT}%)"
    else
        echo -e "  状态: ${GREEN}✅ 正常${RESET}  已用: $USED / 总计: $TOTAL (${PCT}%)"
    fi
}

# ---- 函数：内存检查 ----
check_memory() {
    echo ""
    echo -e "${BOLD}>>> 内存使用率${RESET}"
    USED=$(free -h | awk 'NR==2{print $3}')
    TOTAL=$(free -h | awk 'NR==2{print $2}')
    PCT=$(free | awk 'NR==2{printf "%.0f", $3/$2*100}')
    
    if [ "$PCT" -gt "$MEM_WARN" ]; then
        echo -e "  状态: ${RED}⚠ 告警${RESET}  已用: $USED / 总计: $TOTAL (${PCT}%)"
    else
        echo -e "  状态: ${GREEN}✅ 正常${RESET}  已用: $USED / 总计: $TOTAL (${PCT}%)"
    fi
}

# ---- 函数：负载检查 ----
check_load() {
    echo ""
    echo -e "${BOLD}>>> 系统负载${RESET}"
    LOAD=$(uptime | awk -F'load average:' '{print $2}')
    echo -e "  负载:${LOAD}"
}

# ---- 函数：容器检查 ----
check_containers() {
    echo ""
    echo -e "${BOLD}>>> 容器运行状态${RESET}"
    docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || echo "  Docker 未运行"
}

# ---- 函数：Nginx 检查 ----
check_nginx() {
    echo ""
    echo -e "${BOLD}>>> Nginx 响应${RESET}"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://localhost -k 2>/dev/null)
    case "$HTTP_CODE" in
        200|301|302)
            echo -e "  Nginx: ${GREEN}✅ 正常${RESET} (HTTP $HTTP_CODE)" ;;
        *)
            echo -e "  Nginx: ${RED}❌ 异常${RESET} (HTTP $HTTP_CODE)" ;;
    esac
}

# ---- 函数：备份状态 ----
check_backup() {
    echo ""
    echo -e "${BOLD}>>> 最近备份${RESET}"
    LATEST=$(ls -lt ~/backups/blog-backup-*.tar.gz 2>/dev/null | head -1 | awk '{print $NF, $5"字节", $6, $7}')
    if [ -n "$LATEST" ]; then
        echo -e "  ${GREEN}✅${RESET} $LATEST"
    else
        echo -e "  ${YELLOW}⚠ 未找到备份文件${RESET}"
    fi
}

# ---- 执行所有检查 ----
check_disk
check_memory
check_load
check_containers
check_nginx
check_backup

echo ""
echo -e "${BOLD}========================================${RESET}"
echo -e "${BOLD}  检查完成${RESET}"
echo -e "${BOLD}========================================${RESET}"
echo ""

#!/bin/bash
# ============================================
# Nginx 访问日志分析
# 用法: ./log-report.sh [容器名|日志文件]
# ============================================
set -euo pipefail
BD='\033[1m'; RS='\033[0m'

if [ $# -eq 0 ]; then LOG=$(docker logs blog-nginx 2>&1 || true); SRC="blog-nginx 容器"
elif [ -f "$1" ]; then LOG=$(cat "$1"); SRC="$1"
else LOG=$(docker logs "$1" 2>&1 || true); SRC="$1 容器"; fi

echo -e "${BD}===== Nginx 访问统计 =====${RS}"
echo -e "来源: $SRC"

T=$(echo "$LOG"|grep -cE '"GET|"POST|"HEAD'); echo -e "\n${BD}总请求:${RS} $T"

echo -e "\n${BD}Top 5 IP:${RS}"
echo "$LOG"|grep -oP '^\d+\.\d+\.\d+\.\d+'|sort|uniq -c|sort -rn|head -5|awk '{printf "  %3d次  %s\n",$1,$2}'

echo -e "\n${BD}状态码:${RS}"
echo "$LOG"|grep -E '"GET|"POST|"HEAD'|awk '{print $9}'|grep -E '^[0-9]+$'|sort|uniq -c|sort -rn|awk '{printf "  %3d次  %s\n",$1,$2}'

echo -e "\n${BD}404 排行:${RS}"
echo "$LOG"|grep ' 404 '|awk '{print $7}'|sort|uniq -c|sort -rn|head -5|awk '{printf "  %3d次  %s\n",$1,$2}'

SC=$(echo "$LOG"|grep -cE '\.env|\.git/config|wp-admin|phpmyadmin|\.php|/admin'||true)
[ $SC -gt 0 ] && echo -e "\n  ⚠ 发现 ${SC} 次可疑扫描" || echo -e "\n  ✅ 无可疑扫描"
echo ""

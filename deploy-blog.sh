#!/bin/bash
# ============================================
#  博客一键部署 — 本地生成 → 上传 ECS → 重启
# ============================================

ECS_USER="bing"
ECS_HOST="47.99.166.175"
SSH_KEY="$HOME/.ssh/bing-key.pem"

echo ""
echo "========================================"
echo "  博客一键部署"
echo "========================================"

# 第 1 步：生成静态文件
echo ""
echo ">>> 第 1 步：生成博客静态文件..."
cd ~/my-blog
hexo generate
if [ $? -ne 0 ]; then
    echo "❌ 生成失败，请检查错误信息"
    exit 1
fi
echo "✅ 生成完成"

# 第 2 步：上传到 ECS
echo ""
echo ">>> 第 2 步：上传到 ECS..."
scp -i "$SSH_KEY" -r ~/my-blog/public/* ${ECS_USER}@${ECS_HOST}:~/blog-static/ 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ 上传完成"
else
    echo "❌ 上传失败"
    exit 1
fi

# 第 3 步：重启 Nginx
echo ""
echo ">>> 第 3 步：重启 Nginx..."
ssh -i "$SSH_KEY" ${ECS_USER}@${ECS_HOST} "cd ~/blog-compose && docker compose restart nginx" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Nginx 重启完成"
else
    echo "❌ Nginx 重启失败"
    exit 1
fi

# 第 4 步：验证
echo ""
echo ">>> 第 4 步：验证..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://${ECS_HOST} -k 2>/dev/null)
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ]; then
    echo "✅ 验证通过 (HTTP $HTTP_CODE)"
    echo ""
    echo "博客已上线：https://${ECS_HOST}"
else
    echo "❌ 验证失败 (HTTP $HTTP_CODE)"
fi

echo ""
echo "========================================"
echo "  部署完成"
echo "========================================"
echo ""

# Ops Portfolio — 运维学习项目

## 服务器
阿里云 ECS e实例 2核2G (Alibaba Cloud Linux)
IP: 47.99.166.175

## 已部署服务
- **Nginx** (HTTPS, 自签名证书)
- **Glances** 系统监控 (:8080)
- **个人博客** (Hexo 静态文件)

## 自动化
- backup.sh — 每日备份 (crontab 03:00)
- check.sh — 一键健康检查

## 安全
- SSH 密钥认证，禁止 root 登录
- fail2ban 防暴力破解

## 技术栈
Docker · Docker Compose · Nginx · SSL/TLS · Shell · Linux

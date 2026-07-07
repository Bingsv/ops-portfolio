# 🚀 Ops Portfolio — 运维学习项目

> 阿里云 ECS 从零搭建 | Docker 容器化 | CI/CD 自动化 | 监控 & 安全

---

## 架构总览


                          ┌─────────────────────┐
                          │   GitHub Actions     │
                          │   (blog-source)      │
                          │   push → build → scp │
                          └──────────┬──────────┘
                                     │
                          ┌──────────▼──────────┐
                          │   阿里云 ECS 杭州    │
                          │   47.99.166.175     │
                          │                     │
                          │  ┌───────────────┐  │
                          │  │ docker compose │  │
                          │  │               │  │
                          │  │ blog-nginx    │  │
                          │  │ :80 → :443    │  │
                          │  │ 博客 + 导航页  │  │
                          │  │               │  │
                          │  │ glances       │  │
                          │  │ :8080 监控面板 │  │
                          │  └───────────────┘  │
                          │                     │
                          │  cron:              │
                          │  ├ 03:00 backup.sh  │
                          │  └ */30 monitor.py  │
                          │                     │
                          │  安全:              │
                          │  ├ SSH 密钥登录     │
                          │  ├ 禁止 root        │
                          │  └ fail2ban         │
                          └─────────────────────┘


## 文件说明

| 文件 | 说明 |
|------|------|
| `docker-compose.yml` | Nginx + Glances 容器编排 |
| `Dockerfile` | 博客自定义镜像（基于 nginx:alpine） |
| `nginx-config/default.conf` | Nginx 配置：HTTP→HTTPS 跳转，SSL 证书 |
| `backup.sh` | 每日自动备份脚本（cron 03:00） |
| `check.sh` | 一键健康检查（磁盘/内存/容器/Nginx/备份） |
| `deploy-blog.sh` | 博客一键部署（本地 → ECS） |
| `log-report.sh` | Nginx 访问日志分析报告 |
| `health.py` | Python 版健康检查 |
| `monitor.py` | Python 网站可用性监控（每30分钟） |

## 技术栈

`Linux` `Docker` `Docker Compose` `Dockerfile` `Nginx` `HTTPS/SSL`
`Shell Script` `Python` `GitHub Actions` `CI/CD` `cron` `fail2ban`
`阿里云 ECS` `阿里云 ACR` `Git`

## 相关链接

- 📝 **博客**: [https://47.99.166.175](https://47.99.166.175)
- 📊 **服务器监控**: [http://47.99.166.175:8080](http://47.99.166.175:8080)
- 🔧 **博客源码 + CI/CD**: [blog-source](https://github.com/Bingsv/blog-source)

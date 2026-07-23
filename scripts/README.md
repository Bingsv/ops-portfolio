# 🛠 自动化运维脚本集

服务器日常运维脚本集合——备份、巡检、日志分析、可用性监控。

## 脚本清单

### Shell (`shell/`)

| 脚本 | 功能 | 用法 |
|------|------|------|
| `check.sh` | 全维度巡检（系统/容器/网络/安全/备份） | `bash check.sh` |
| `backup.sh` | 博客 & 配置打包备份，支持滚动清理 | `bash backup.sh [保留天数]` |
| `log-report.sh` | Nginx 日志分析（IP/状态码/404/可疑扫描） | `bash log-report.sh [容器名\|日志文件]` |

### Python (`python/`)

| 脚本 | 功能 | 用法 |
|------|------|------|
| `monitor.py` | 多站点可用性监控，支持 JSON 输出 | `python3 monitor.py [--json]` |
| `health.py` | 服务器健康检查 Python 版 | `python3 health.py` |

## 定时任务

```
# 每天凌晨 3 点备份，保留 7 天
0 3 * * * /home/bing/backup.sh 7

# 每 30 分钟检查网站可用性
*/30 * * * * python3 /home/bing/monitor.py >> /home/bing/monitor.log
```

## 面试话术

> "我写了 5 个自动化运维脚本——巡检、备份、日志分析、网站监控。check.sh 检查系统资源、容器、网络、安全、备份五个维度，异常项标红。monitor.py 用 requests 库监控多个站点，区分超时和连接失败。所有脚本都支持参数化配置，代码在 GitHub 的 ops-portfolio 仓库。"

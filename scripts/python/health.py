#!/usr/bin/env python3
"""服务器健康检查 — Python 版 — 用法: python3 health.py"""
import os
GN, RD, YL, BD, RS = '\033[32m', '\033[31m', '\033[33m', '\033[1m', '\033[0m'

def run(cmd): return os.popen(cmd).read().strip()

def check_disk(warn=80):
    d = run("df -h /").split("\n")[1].split(); p = int(d[4].replace('%',''))
    c, i = (RD,'⚠') if p>warn else (GN,'✅')
    print(f"  {c}{i}{RS}  磁盘: {d[2]}/{d[1]} ({p}%)")

def check_memory(warn=90):
    r = run("free").split("\n")[1].split(); p = int(r[2])*100//int(r[1])
    h = run("free -h").split("\n")[1].split()
    c, i = (RD,'⚠') if p>warn else (GN,'✅')
    print(f"  {c}{i}{RS}  内存: {h[2]}/{h[1]} ({p}%)")

def check_load():
    l = run("cat /proc/loadavg").split()[:3]
    print(f"  ✅  负载: {' '.join(l)}")

def check_nginx():
    code = run("curl -s -o /dev/null -w '%{http_code}' https://localhost -k")
    c = GN if code in ('200','301','302') else RD
    print(f"  {c}{'✅' if c==GN else '❌'}{RS}  Nginx: HTTP {code}")

def check_docker():
    n = len(run("docker ps -q 2>/dev/null").split())
    print(f"  {GN if n>0 else YL}{'✅' if n>0 else '⚠'}{RS}   Docker: {n} 个容器")

print(f"\n{BD}===== 服务器健康检查 (Python) ====={RS}")
print(f"  时间: {run('date')}")
check_disk(); check_memory(); check_load(); check_nginx(); check_docker()
print(f"{BD}====================================={RS}\n")

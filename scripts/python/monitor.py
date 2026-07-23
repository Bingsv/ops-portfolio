#!/usr/bin/env python3
"""网站可用性监控 — 用法: python3 monitor.py [--json]"""
import requests, urllib3, sys, json
from datetime import datetime
urllib3.disable_warnings()

URLS = [
    ("博客", "https://47.99.166.175"),
    ("Prometheus", "http://47.99.166.175:9090"),
    ("Grafana", "http://47.99.166.175:3000"),
    ("GitHub", "https://github.com"),
]
GN, RD, RS = '\033[32m', '\033[31m', '\033[0m'

def check(name, url):
    try:
        r = requests.get(url, timeout=10, verify=False)
        return {"name": name, "ok": True, "status": f"HTTP {r.status_code}", "speed": f"{r.elapsed.total_seconds():.2f}s"}
    except requests.ConnectionError:
        return {"name": name, "ok": False, "status": "连接失败", "speed": "-"}
    except requests.Timeout:
        return {"name": name, "ok": False, "status": "超时", "speed": "-"}

results = [check(n,u) for n,u in URLS]
out = "--json" in sys.argv
if out:
    print(json.dumps(results, indent=2))
else:
    print(f"\n===== 网站监控 — {datetime.now().strftime('%Y-%m-%d %H:%M')} =====")
    for r in results:
        c = GN if r["ok"] else RD; i = "✅" if r["ok"] else "❌"
        print(f"  {c}{i}{RS}  {r['name']:12s}  {r['status']:12s}  {r['speed']}")
    a = "全部正常 ✅" if all(r["ok"] for r in results) else "有异常 ❌"
    print(f"===== {a} =====\n")

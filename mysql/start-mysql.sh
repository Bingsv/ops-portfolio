#!/bin/bash
# 一键启动 MySQL 学习环境
docker run -d --name mysql-learn \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=Admin@123 \
  -e MYSQL_DATABASE=opsdb \
  mysql:8.0

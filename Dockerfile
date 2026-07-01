FROM nginx:alpine

# 复制博客文件
COPY blog-static/ /usr/share/nginx/html/

# 复制 nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 复制 SSL 证书
COPY certs/ /etc/nginx/certs/

EXPOSE 80 443

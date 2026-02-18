FROM nginx:alpine

# Create self-signed certificate for port 443 (needed for Cloudflare Full SSL mode)
RUN apk add --no-cache openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/blog.wangxiaoyuan.top.key \
    -out /etc/nginx/ssl/blog.wangxiaoyuan.top.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=blog.wangxiaoyuan.top"

# Copy nginx configuration
COPY nginx-proxy-simple.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443
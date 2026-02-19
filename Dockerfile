# Build stage - build Hugo site
FROM hugomods/hugo:latest AS builder
WORKDIR /src
COPY . .
RUN hugo --minify

# Production stage - serve the built site
FROM nginx:alpine
COPY --from=builder /src/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8081
CMD ["nginx", "-g", "daemon off;"]
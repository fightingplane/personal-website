FROM klakegg/hugo:0.146.0-ext-alpine AS builder

# Copy site source
WORKDIR /src
COPY . .

# Build the site
RUN hugo --minify

# Production stage
FROM nginx:alpine

# Copy built site from builder stage
COPY --from=builder /src/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Nginx will start automatically
CMD ["nginx", "-g", "daemon off;"]
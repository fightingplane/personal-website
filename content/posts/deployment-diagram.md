---
title: "Deployment Architecture Diagram"
date: 2026-02-09T19:25:00+08:00
draft: false
author: "Rocky Wang"
tags: ["architecture", "deployment", "diagram", "infrastructure"]
categories: ["tutorial", "web development"]
---

# Personal Website Deployment Architecture

Here's a visual representation of how your personal website is deployed:

```
┌─────────────────────────────────────────────────────────────────┐
│                        Cloudflare CDN                           │
│                                                                 │
│  HTTPS (SSL Termination)                                        │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                                                         │    │
│  │  DNS: blog.wangxiaoyuan.top → [Your Server IP]          │    │
│  │                                                         │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  │ HTTP (Port 80/443)
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Your Server                              │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                  Nginx Reverse Proxy                    │    │
│  │                                                         │    │
│  │  • Listens on ports 80/443                              │    │
│  │  • Handles SSL certificates (self-signed)                │    │
│  │  • Routes traffic to Hugo container                     │    │
│  │  • Virtual host: blog.wangxiaoyuan.top                  │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                  │                             │
│                                  │ Internal Network            │
│                                  ▼                             │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Hugo Web Server                      │    │
│  │                                                         │    │
│  │  • Serves static files from /public directory           │    │
│  │  • Runs on port 8081                                    │    │
│  │  • Built with Hugo + PaperMod theme                     │    │
│  │  • Contains all your content (posts, videos, about)     │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Docker Network: personal-website-network                       │
│  • Isolates containers from host network                        │
│  • Enables secure internal communication                        │
└─────────────────────────────────────────────────────────────────┘
                                  │
                                  │ File System Access
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Repository                            │
│                                                                 │
│  https://github.com/fightingplane/personal-website              │
│                                                                 │
│  • Source code and configuration                                │
│  • Hugo site files (.md, .toml, etc.)                          │
│  • Docker configurations                                       │
│  • Nginx configurations                                        │
│  • All changes automatically committed                         │
└─────────────────────────────────────────────────────────────────┘
```

## Component Breakdown

### **Cloudflare Layer**
- **SSL Termination**: Handles HTTPS encryption/decryption
- **CDN Caching**: Improves global performance
- **DDoS Protection**: Security at the edge
- **DNS Management**: Points your domain to your server

### **Nginx Reverse Proxy**
- **Public Interface**: Listens on standard HTTP/HTTPS ports (80/443)
- **SSL Handling**: Uses self-signed certificates for Cloudflare Full SSL mode
- **Traffic Routing**: Forwards requests to the internal Hugo container
- **Virtual Hosting**: Supports multiple domains if needed

### **Hugo Container**
- **Static Site**: Serves pre-built HTML/CSS/JS files
- **Internal Port**: Runs on port 8081 (not publicly exposed)
- **Content Management**: All your posts, pages, and media
- **Theme**: PaperMod provides responsive design and features

### **Docker Network**
- **Isolation**: Containers communicate securely without exposing to public internet
- **Scalability**: Easy to add more services (database, cache, etc.)
- **Portability**: Same setup works on any Docker-enabled server

### **GitHub Integration**
- **Version Control**: All configuration and content tracked in Git
- **Backup**: Automatic backup of your entire site
- **Collaboration**: Easy to share or work with others
- **CI/CD Ready**: Foundation for automated deployments

## Data Flow

1. **User Request**: `https://blog.wangxiaoyuan.top` 
2. **Cloudflare**: Terminates SSL, forwards HTTP to your server
3. **Nginx**: Receives request on port 443, routes to Hugo container on port 8081
4. **Hugo**: Serves static HTML file from `/public` directory
5. **Response**: Travels back through Nginx → Cloudflare → User's browser

This architecture provides security, performance, and maintainability while keeping everything under your control!
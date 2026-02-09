---
title: "Set up my personal site with OpenClaw"
date: 2026-02-09T19:21:00+08:00
draft: false
author: "Rocky Wang"
tags: ["personal", "website", "hugo", "docker", "openclaw"]
categories: ["tutorial", "web development"]
---

# Set up my personal site with OpenClaw

Setting up a personal website has always been on my to-do list, but the technical complexity often held me back. Thanks to **OpenClaw**, an AI assistant that can execute commands and manage infrastructure, I was able to build and deploy a professional personal website in just a few hours!

## Purpose

My goal was simple: create a self-hosted personal website where I can share:
- Technical articles and tutorials
- Video content and demonstrations  
- Project updates and insights
- Thoughts on software architecture and development

I wanted full control over my content without relying on commercial platforms like Medium or WordPress.com. The solution needed to be:
- **Self-hosted** on my own server
- **Containerized** using Docker for easy deployment
- **Secure** with HTTPS via Cloudflare
- **Professional** with my own domain and branding

## Site Structure

The final architecture consists of several key components:

### Hugo + PaperMod Theme
- **Static site generator**: Hugo (v0.146.0)
- **Theme**: PaperMod - clean, responsive, and feature-rich
- **Content structure**: 
  - `/posts/` - Technical articles and tutorials
  - `/videos/` - Video content and demonstrations  
  - `/about/` - Personal bio and social links

### Docker Deployment
- **Hugo container**: Serves static files on port 8081
- **Nginx reverse proxy**: Handles HTTP/HTTPS on ports 80/443
- **Docker network**: Isolates containers while allowing communication

### Domain & Security
- **Custom domain**: `blog.wangxiaoyuan.top`
- **SSL termination**: Cloudflare Full SSL mode
- **Social integration**: GitHub and Facebook profiles linked

### Personal Branding
- **Profile picture**: Rounded avatar in top-left corner
- **Social media**: Direct links to GitHub and Facebook
- **Responsive design**: Works on all devices

## Deployment Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Cloudflare CDN/SSL                       │
│  ┌─────────────────────────────────────────────────────┐  │
│  │                DNS: blog.wangxiaoyuan.top           │  │
│  └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ HTTPS (Port 443)
┌─────────────────────────────────────────────────────────────┐
│                    Your Server (VPS)                        │
│                                                             │
│  ┌─────────────────┐     ┌─────────────────────────────┐   │
│  │   Nginx Proxy   │◄───►│    Docker Network           │   │
│  │  (Ports 80/443) │     │  personal-website-network   │   │
│  └─────────────────┘     └─────────────────────────────┘   │
│            ▲                           │                    │
│            │ HTTP                      │ Internal HTTP      │
│            │                           ▼                    │
│     ┌─────────────────┐     ┌─────────────────────────────┐│
│     │   Self-signed   │     │    Hugo Static Site         ││
│     │    Certificates │     │    Container                ││
│     └─────────────────┘     │    (Port 8081)              ││
│                             │                             ││
│                             │  • Hugo v0.146.0           ││
│                             │  • PaperMod Theme          ││
│                             │  • Static HTML/CSS/JS      ││
│                             └─────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘

Key Components:
• Cloudflare: Handles DNS, SSL termination, and CDN caching
• Nginx: Reverse proxy that routes traffic to Hugo container
• Docker Network: Secure internal communication between containers  
• Hugo Container: Serves your static website files
• GitHub Repository: Version control for all site files and configuration
```

## Step-by-Step Process

### 1. Initial Setup
OpenClaw helped me create the foundation:
- Generated a new Hugo site with PaperMod theme
- Configured the basic `config.toml` with proper baseURL
- Set up the initial content structure with posts, videos, and about sections

### 2. Social Media Integration  
We added my social profiles to make the site more personal:
- **GitHub**: https://github.com/fightingplane
- **Facebook**: https://www.facebook.com/wangxiaoyuan1987
- These appear both in the header navigation and on the About page

### 3. Docker Containerization
To ensure easy deployment and isolation:
- Created a multi-container setup with Hugo and Nginx
- Built custom Docker images for both services
- Configured Docker networking between containers

### 4. Nginx Reverse Proxy Configuration
For proper web serving and SSL support:
- Set up Nginx to proxy requests to the Hugo container
- Configured virtual host for `blog.wangxiaoyuan.top`
- Added self-signed certificates for Cloudflare Full SSL mode

### 5. Domain and Cloudflare Setup
Made the site accessible via my custom domain:
- Pointed DNS A record to my server IP
- Configured Cloudflare SSL/TLS to "Full" mode
- Enabled HTTPS with automatic certificate management

### 6. Personal Branding Enhancements
Added the finishing touches to make it truly mine:
- Uploaded and integrated my profile picture from Facebook
- Created custom JavaScript to display a rounded avatar in the top-left corner
- Ensured the avatar appears globally across all pages

### 7. Continuous Deployment
Set up a workflow for future updates:
- All changes automatically committed to GitHub repository
- Simple rebuild/deploy scripts for content updates
- Version-controlled configuration and assets

## The Power of AI-Assisted Development

What made this project possible was having an AI assistant that could actually **execute commands** rather than just provide instructions. OpenClaw handled:

- **File creation and editing**: Writing configuration files, content, and scripts
- **Command execution**: Running Hugo builds, Docker commands, and system operations  
- **Troubleshooting**: Debugging issues with CSS loading, theme configuration, and deployment
- **Version control**: Automatically committing all changes to GitHub
- **Infrastructure management**: Setting up Docker networks, containers, and Nginx configuration

Instead of spending days figuring out Hugo themes, Docker networking, and Nginx configuration, I was able to focus on the content and vision while OpenClaw handled the technical implementation.

## Next Steps

Now that the foundation is solid, I plan to:
- Write more technical articles about software architecture
- Create video tutorials for complex topics
- Add more interactive features as needed
- Continue leveraging AI assistance for maintenance and enhancements

The site is live at [https://blog.wangxiaoyuan.top](https://blog.wangxiaoyuan.top) - feel free to explore and subscribe for future updates!

---

*This post was created with the help of OpenClaw, demonstrating the power of AI-assisted development in action.*
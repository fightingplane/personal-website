---
title: "How to publish your website on Cloudflare for free"
date: 2026-11-08T18:00:00+08:00
draft: false
author: "Rocky Wang"
description: "Why I host my personal website on Cloudflare for free — the services a personal site actually needs, the overall deployment architecture, how this Hugo site ships with Cloudflare Workers, and the results."
tags: ["Cloudflare", "Hugo", "Static Site", "Deployment", "Free Hosting", "Architecture"]
categories: ["tutorial", "web development"]
faq:
  - question: "Is Cloudflare hosting really free?"
    answer: "Yes. Cloudflare Pages offers unlimited static requests, unlimited bandwidth, and free SSL on the free plan (with a monthly build limit). The Cloudflare Workers free plan includes around 100,000 requests per day, which is plenty for a personal website."
  - question: "Why choose Cloudflare over GitHub Pages, Vercel, or Netlify?"
    answer: "Cloudflare's free tier is the most generous for static sites (unlimited bandwidth and requests on Pages), it runs on a global edge network, and it bundles DNS, CDN, TLS, and DDoS protection in one place. The tradeoff is a slightly more infrastructure-oriented setup."
  - question: "Do I need my own server?"
    answer: "No. Your site is built in CI and served as static files from Cloudflare's edge. There is no server to patch, scale, or pay for."
  - question: "What does the free plan not include?"
    answer: "The main limits are the Workers free plan's daily request cap (~100,000/day), a monthly cap on Pages builds, and fewer edge locations for some advanced features. For a personal site these limits are rarely hit."
  - question: "How is this site deployed?"
    answer: "This Hugo site is deployed as Cloudflare Workers with static assets. A bundled Hugo binary builds the site in the Cloudflare build environment, and every push to master triggers a build and a deploy to the edge."
howto:
  - name: "Put your source on GitHub"
    text: "Commit your static site source (not the generated output) to a GitHub repository."
  - name: "Connect the repository"
    text: "Create a Cloudflare Pages project or configure Workers Builds against your repository."
  - name: "Configure the build"
    text: "Set the build command (for example, hugo --minify) and the output directory (for example, public)."
  - name: "Build the site"
    text: "Cloudflare runs the build in CI and produces static files in the output directory."
  - name: "Deploy to the edge"
    text: "The static files are uploaded and served from Cloudflare's global edge network."
  - name: "Attach a custom domain"
    text: "Point your domain at Cloudflare and let it issue a free SSL certificate automatically."
---

## 1. Why choose Cloudflare?

**I host this site on Cloudflare because it is free, global, and serverless:** unlimited bandwidth, automatic HTTPS, and a worldwide CDN, all without a server to maintain.

Traditional hosting means renting a VPS, installing Nginx, renewing certificates, and patching the OS. For a personal website that is a lot of overhead for something that, at its core, just serves static files. Cloudflare turns that into a build-and-forget pipeline.

The main reasons:

- **A genuinely generous free tier.** Cloudflare Pages includes unlimited static requests and unlimited bandwidth; the Workers free plan includes roughly 100,000 requests per day.
- **A global edge network.** Assets are served from 300+ cities, so visitors get low latency wherever they are — without you configuring a single region.
- **Automatic HTTPS.** Free SSL/TLS certificates are issued and renewed for you.
- **Built-in DDoS protection.** The same edge that serves your site absorbs attacks.
- **DNS + CDN + TLS in one place.** If your domain uses Cloudflare DNS, everything is managed in one dashboard.
- **Git-connected deploys.** Push to a branch and the site rebuilds and deploys automatically.
- **No server to maintain.** There is nothing to patch, scale, or keep online.

### How it compares

| Platform | Free bandwidth | Server-side logic | Custom domain + TLS | Notes |
|----------|----------------|-------------------|---------------------|-------|
| **Cloudflare** (Pages / Workers) | Unlimited (Pages); ~100k req/day (Workers) | Workers | Free | Global edge, built-in DDoS |
| GitHub Pages | ~100 GB/month (soft) | No | Free | Simplest; GitHub-only, no functions |
| Netlify | ~100 GB/month | Functions | Free | Very easy DX |
| Vercel | ~100 GB/month | Functions | Free | Great DX; hobby-plan limits |

Approximate figures at the time of writing — check each provider for current limits.

### The tradeoffs

Cloudflare is not the "one-click" option. Two products — **Pages** and **Workers** — can be confusing, the build environment is more constrained than a full VM, and the Workers free plan has a daily request cap. But for a static personal site, none of these are real obstacles, and the free tier is hard to beat.

## 2. What services does a personal website use?

A personal website needs surprisingly little. Here's how each need maps to a Cloudflare service:

| Need | Cloudflare service | Free? |
|------|--------------------|-------|
| Domain & DNS | Cloudflare DNS | Yes |
| Static hosting | Pages or Workers static assets | Yes |
| HTTPS certificates | Universal SSL | Yes |
| Global CDN & caching | Cloudflare CDN | Yes |
| Build & deploy (CI/CD) | Pages builds / Workers Builds | Yes |
| DDoS protection | Automatic edge protection | Yes |
| Privacy-friendly analytics | Cloudflare Web Analytics | Yes |
| Email forwarding | Email Routing | Yes (optional) |
| Image/asset storage | R2 object storage | Generous free tier (optional) |
| Dynamic data | Workers + KV / D1 | Free tier (optional) |

For most personal sites you only touch the first five to seven rows. The rest are there if the site grows: R2 if you have large media, Workers KV or D1 if you add comments, a newsletter, or other dynamic features.

## 3. What does the overall deployment architecture look like?

**The architecture is a static-site pipeline:** source in Git → build in CI → static files → Cloudflare edge → visitor. There is no traditional origin server in the request path.

```
Developer
   │  git push
   ▼
GitHub repository (source: content/, config, theme)
   │  webhook / Workers Builds
   ▼
Build step  (hugo --minify  →  public/)
   │  static assets
   ▼
Cloudflare Edge  (CDN cache + TLS + DDoS protection)
   │  HTTPS
   ▼
Visitor
```

Walking through the flow:

1. **Source.** Your content and configuration live in a Git repository — never the generated output.
2. **Build.** A push triggers CI, which runs the build command (for a Hugo site, `hugo --minify`) and produces static files in an output folder (Hugo → `public/`).
3. **Deploy.** The static assets are uploaded to Cloudflare and distributed to the edge.
4. **Serve.** Visitors hit the nearest edge location; cached assets are returned immediately, and Cloudflare terminates TLS.
5. **Domain.** If your domain uses Cloudflare DNS, it points at the project or Worker and gets a free certificate automatically.

Because every asset is static and cached at the edge, there is no database, no application server, and nothing to scale.

## 4. How is this site deployed?

This site is a **Hugo + PaperMod** blog served as **Cloudflare Workers with static assets** — the Workers path rather than Pages.

### The shape of the setup

- **Generator:** Hugo with the PaperMod theme.
- **Hosting model:** Cloudflare Workers static assets.
- **Build/deploy config:** a single `wrangler.toml` at the repo root.
- **Trigger:** every push to `master`.
- **Domain:** a custom domain routed through Cloudflare DNS.

The configuration is small:

```toml
name = "personal-website"
compatibility_date = "2026-09-17"

[build]
command = "./bin/hugo --minify"

[assets]
directory = "./public"
```

- `[build] command` runs before each deploy.
- `[assets] directory` tells Workers which folder to serve as static files.

### One hard-won detail: the bundled Hugo binary

The build command is `./bin/hugo --minify`, not `hugo --minify`. That is deliberate.

The Cloudflare build environment does not ship a recent Hugo, and downloading it from GitHub releases during the build proved unreliable — the download would intermittently return an error page instead of the archive, failing the build with `gzip: stdin: not in gzip format`.

The fix was to **bundle the Linux Hugo binary** at `bin/hugo` in the repository and call it directly. The build is now deterministic and no longer depends on a network download at deploy time.

### The deploy flow for this site

1. Push to `master`.
2. Cloudflare runs `./bin/hugo --minify`, producing `public/`.
3. The static files in `public/` are uploaded as the Worker's assets.
4. The site is live on the edge behind the custom domain, with TLS handled by Cloudflare.

No server, no Nginx, no certificate cron job — the repository is the source of truth.

## 5. What are the results?

**The result is a fast, free, zero-maintenance site:** $0 in hosting, automatic HTTPS, global edge delivery, and deploys triggered by a single `git push`.

| Metric | Result |
|--------|--------|
| Hosting cost | $0 (free plan) |
| HTTPS | Automatic, auto-renewed |
| Delivery | Global edge CDN (300+ cities) |
| Deploy trigger | Push to `master` |
| Server maintenance | None |
| DDoS protection | Included |
| Build environment | Constrained; bundle toolchain for reproducibility |
| Request ceiling | ~100k/day on the Workers free plan |

### What this means in practice

- **Cost:** hosting a personal site costs nothing beyond the domain (which you may already own). There is no monthly VPS bill.
- **Performance:** static assets served from the edge are fast worldwide, and caching means repeat visits are near-instant.
- **Operations:** there is no server to patch or scale. The tradeoff is that you must understand a build step and keep the toolchain pinned.
- **SEO and GEO:** fast pages, HTTPS, a clean sitemap, and structured data all come through with the same pipeline — the site is as ready for search engines as it is for readers.
- **Limits:** the Workers free plan caps requests per day and Pages caps builds per month. For a personal site these are effectively out of reach; if you ever exceed them, scaling up is a paid-plan change, not a re-architecture.

### Frequently asked questions

**Is Cloudflare hosting really free?**
Yes. Pages includes unlimited static requests and bandwidth; Workers' free plan includes roughly 100,000 requests per day — plenty for a personal site.

**Why choose Cloudflare over GitHub Pages, Vercel, or Netlify?**
The free tier is the most generous for static sites, it runs on a global edge, and DNS/CDN/TLS/DDoS are bundled together. The tradeoff is a more infrastructure-oriented setup.

**Do I need my own server?**
No. The site is built in CI and served as static files from the edge — nothing to patch, scale, or pay for.

**How is this site deployed?**
As Cloudflare Workers with static assets: a bundled Hugo binary builds the site, and every push to `master` triggers a build and deploy.

---

**Bottom line:** for a personal website, Cloudflare is the rare "free and actually good" combination — a static pipeline with a global CDN, automatic HTTPS, and no server to babysit. The one thing worth getting right is the build step: pin your toolchain so deploys stay reproducible.

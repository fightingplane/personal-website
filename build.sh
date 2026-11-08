#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Building Hugo Personal Website${NC}"

if ! command -v hugo &> /dev/null; then
    echo -e "${RED}❌ Hugo is not installed. Please install Hugo first.${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 Building Hugo site...${NC}"
hugo --minify
echo -e "${GREEN}✅ Hugo site built successfully!${NC}"

echo -e "${YELLOW}🐳 Building Docker image...${NC}"
docker build -t personal-website .
echo -e "${GREEN}✅ Docker image built successfully!${NC}"

echo -e "${GREEN}🎉 Build completed successfully!${NC}"
echo -e "${YELLOW}To deploy, run: ./deploy.sh${NC}"

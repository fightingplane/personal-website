#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Building Hugo Personal Website${NC}"

# Check if hugo is installed
if ! command -v hugo &> /dev/null; then
    echo -e "${RED}❌ Hugo is not installed. Please install Hugo first.${NC}"
    exit 1
fi

# Build the Hugo site
echo -e "${YELLOW}📦 Building Hugo site...${NC}"
hugo --minify

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Hugo site built successfully!${NC}"
else
    echo -e "${RED}❌ Hugo build failed!${NC}"
    exit 1
fi

# Build Docker image
echo -e "${YELLOW}🐳 Building Docker image...${NC}"
docker build -t personal-website .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker image built successfully!${NC}"
else
    echo -e "${RED}❌ Docker build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Build completed successfully!${NC}"
echo -e "${YELLOW}To deploy, run: ./deploy.sh${NC}"
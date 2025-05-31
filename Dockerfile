FROM node:20-alpine

# Install dependencies
RUN apk add --no-cache \
    git \
    curl \
    make \
    g++ \
    libc6-compat \
    python3 \
    build-base \
    cairo-dev \
    pango-dev \
    chromium

# Puppeteer setup
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Node performance
ENV NODE_OPTIONS=--max-old-space-size=8192

# Working directory
WORKDIR /usr/src

# Install pnpm
RUN npm install -g pnpm

# Copy Flowise source code into container
COPY . .

# Install deps and build
RUN pnpm install && pnpm build

# Expose port
EXPOSE 3000

# Start Flowise
CMD ["pnpm", "start"]

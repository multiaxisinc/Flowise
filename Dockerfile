FROM node:20-alpine

# Install required dependencies including Git
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

# Puppeteer + Chromium setup
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Node memory and node path for custom modules
ENV NODE_OPTIONS=--max-old-space-size=8192
ENV NODE_PATH=/root/.flowise/nodes

# Set working directory
WORKDIR /usr/src

# Clone custom nodes from public repo (using git:// to avoid HTTPS auth)
RUN mkdir -p /root/.flowise/nodes && \
    git clone --depth 1 git://github.com/FlowiseAI/flowise-custom-nodes.git /root/.flowise/nodes/flowise-custom-nodes

# Install pnpm
RUN npm install -g pnpm

# Copy Flowise source code
COPY . .

# Install dependencies and build
RUN pnpm install && pnpm build

# Expose port
EXPOSE 3000

# Start Flowise
CMD ["pnpm", "start"]

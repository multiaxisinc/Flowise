FROM node:20-alpine

# Install system dependencies (including Git!)
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

# Puppeteer setup for Flowise
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Increase Node memory and set node path for custom nodes
ENV NODE_OPTIONS=--max-old-space-size=8192
ENV NODE_PATH=/root/.flowise/nodes

# Set working directory
WORKDIR /usr/src

# Clone Flowise community custom nodes (Webhook, Worker, etc.)
RUN mkdir -p /root/.flowise/nodes && \
    git clone https://github.com/FlowiseAI/flowise-custom-nodes.git /root/.flowise/nodes/flowise-custom-nodes

# Install pnpm globally
RUN npm install -g pnpm

# Copy Flowise source code
COPY . .

# Install dependencies and build
RUN pnpm install && pnpm build

# Expose Flowise port
EXPOSE 3000

# Start Flowise
CMD ["pnpm", "start"]

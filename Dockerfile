# Build local monorepo image
# docker build --no-cache -t  flowise .

# Run image
# docker run -d -p 3000:3000 flowise

FROM node:20-alpine

# Install system dependencies
RUN apk add --update libc6-compat python3 make g++
RUN apk add --no-cache build-base cairo-dev pango-dev
RUN apk add --no-cache chromium
RUN apk add --no-cache curl

# Install pnpm globally
RUN npm install -g pnpm

# Puppeteer + Chromium setup
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Node.js memory optimization
ENV NODE_OPTIONS=--max-old-space-size=8192

# Add custom Flowise nodes (Worker, Supervisor, Webhook, etc.)
RUN mkdir -p /root/.flowise/nodes && \
    git clone https://github.com/FlowiseAI/flowise-custom-nodes.git /root/.flowise/nodes/flowise-custom-nodes

# Tell Node.js and Flowise where to find custom nodes
ENV NODE_PATH=/root/.flowise/nodes

# Set working directory
WORKDIR /usr/src

# Copy app source code into container
COPY . .

# Install dependencies and build Flowise
RUN pnpm install
RUN pnpm build

# Expose app port
EXPOSE 3000

# Start Flowise
CMD [ "pnpm", "start" ]

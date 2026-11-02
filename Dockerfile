FROM node:20-slim

# Install pnpm and system dependencies
RUN npm install -g pnpm && \
    apt-get update && apt-get install -y git python3 make g++ && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy configuration metadata
COPY package.json pnpm-lock.yaml* pnpm-workspace.yaml* ./
COPY packages/core/package.json ./packages/core/

# Install workspace dependencies
RUN pnpm install

# Copy application assets
COPY . .

# Compile target packages
RUN cd packages/core && pnpm rewriter:build && cd ../.. && pnpm build

# Expose internal engine mapping port
EXPOSE 4141
ENV PORT=4141

# Start the dev server
CMD ["pnpm", "dev"]

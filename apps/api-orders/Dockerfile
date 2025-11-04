# Use Node.js 20 Alpine for smaller image size
FROM node:20-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Set working directory
WORKDIR /app

# Copy package files from root
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY apps/api-orders/src ./apps/api-orders/src
COPY apps/api-orders/tsconfig*.json ./apps/api-orders/

# Build the application
RUN npx nx build api-orders

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

# Start the application
CMD ["npx", "nx", "serve", "api-orders"]

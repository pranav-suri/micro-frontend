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
COPY apps/api-users/src ./apps/api-users/src
COPY apps/api-users/tsconfig*.json ./apps/api-users/

# Build the application
RUN npx nx build api-users

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

# Start the application
CMD ["npx", "nx", "serve", "api-users"]

# =============================================================================
# Dockerfile for Production Deployment of a Next.js App (with TypeScript)
#
# This Dockerfile uses a two-stage build process:
#
# 1️ Build Stage:
#   - Uses a Node.js image to install dependencies and build the Next.js app.
#   - Copies all source files and compiles the project (including TypeScript).
#
# 2️ Production Stage:
#   - Uses a clean Node.js image to run only the compiled output.
#   - Copies only the necessary files produced during build time.
#   - Uses Next.js standalone output for an optimized and minimal container.
#
# Benefits:
#   - Smaller final image size (no source code, no dev dependencies).
#   - Faster container startup and lower memory usage.
#   - More secure (no need to ship full source).
#
# Usage:
#   docker build -t my-nextjs-app .
#   docker run -p 3000:3000 my-nextjs-app
# =============================================================================

# 1️: Build Stage
FROM node:20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package files and install only prod + build dependencies
COPY package.json package-lock.json* ./
RUN npm install

# Copy the entire project source (including ts files, public, etc.)
COPY . .

# Build the Next.js app (generates .next folder with compiled output)
RUN npm run build

# 2️: Production Stage (only copy what’s needed to run the app)
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy the standalone server files built by Next.js
COPY --from=builder /app/.next/standalone ./

# Copy static files generated by Next.js
COPY --from=builder /app/.next/static ./.next/static

# Copy the public folder (for images, fonts, etc.)
COPY --from=builder /app/public ./public

# Copy package.json just for metadata (optional but helpful)
COPY --from=builder /app/package.json ./package.json

# Expose the port used by the Next.js server
EXPOSE 3000

# Start the production server
CMD ["node", "server.js"]

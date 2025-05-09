FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package.json and lock file (if exists) from the sim directory
# This helps optimize Docker layer caching
COPY sim/package.json sim/package-lock.json* ./
# If you use yarn, it would be: COPY sim/package.json sim/yarn.lock ./
# If you use pnpm, it would be: COPY sim/package.json sim/pnpm-lock.yaml ./

# Install dependencies
# Using --omit=dev or --production might be considered if you have many devDependencies not needed for runtime
# However, Next.js build might need some devDependencies. Sticking to plain npm install for now.
RUN npm install

# Copy the rest of the application code from the sim directory
COPY sim/ ./

# Build the Next.js application for production
RUN npm run build

# Expose the port Next.js will run on. 
# Railway will automatically use this or provide a PORT environment variable.
EXPOSE 3000

# Command to run the application
# `next start` will automatically use the PORT environment variable if set by Railway.
CMD ["npm", "run", "start"]
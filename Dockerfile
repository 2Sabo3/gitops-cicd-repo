# Use an official Alpine-based Node image for minimal attack surface (Best Practice)
FROM node:20.12.2-alpine3.18

# Set labels for metadata tracking


# Set NODE_ENV to production to ensure optimal performance and security configs inside node packages
ENV NODE_ENV=production
ENV PORT=3000

# Create a non-root user group and user with specific UI/GID (Alpine node image already has a 'node' user)
# We leverage the built-in 'node' user

# Set the working directory
WORKDIR /usr/src/app

# Change ownership of the directory to the non-root 'node' user
RUN chown node:node /usr/src/app

# Switch to the non-root user to avoid running everything as root (Security Best Practice)
USER node

# Copy package.json and package-lock.json (if available) before other files
# This leverages Docker cache layers and prevents massive re-installs
# The --chown=node:node ensures files belong to the unprivileged user
COPY --chown=node:node package.json ./

# Install only production dependencies
# Using npm install because we don't have a package-lock.json generated yet in this prompt,
# but ideally we would use `npm ci --only=production` when lockfile exists.
RUN npm install --omit=dev

# Copy the rest of the application code
COPY --chown=node:node server.js ./
COPY --chown=node:node public/ ./public/

# Explicitly expose the port
EXPOSE 3000

# Add a healthcheck to ensure the container is healthy
# Since we use Alpine, we can use wget or build in curl
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# Start the application using dumb-init or directly.
# Since simple express server, node server.js is fine. 
# Best practice is explicitly invoking node avoiding npm wrapper overhead.
CMD ["node", "server.js"]

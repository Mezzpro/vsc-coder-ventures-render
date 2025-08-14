# Use the official code-server image with Node.js support
FROM codercom/code-server:4.103.0

# Switch to root for installations
USER root

# Install Node.js, npm, curl and git
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Verify Node.js installation
RUN node --version && npm --version

# Create workspace directories with proper ownership
RUN mkdir -p /home/coder/workspace-admin \
    /home/coder/workspace-mezzpro \
    && chown -R coder:coder /home/coder

# Copy Node.js files and startup script
COPY package.json /home/coder/package.json
COPY proxy-server.js /home/coder/proxy-server.js
COPY start-both.sh /home/coder/start.sh

# Install Node.js dependencies
RUN cd /home/coder && npm install --production

# Make everything executable and owned by coder
RUN chmod +x /home/coder/start.sh \
    && chown -R coder:coder /home/coder

# Switch back to coder user
USER coder

# Apply VS Code settings
COPY --chown=coder:coder settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Set default working directory
WORKDIR /home/coder

# Port configuration for Render
ENV PORT=10000

# Start with our proxy startup script
ENTRYPOINT ["/home/coder/start.sh"]
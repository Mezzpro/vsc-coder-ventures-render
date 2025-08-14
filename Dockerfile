# Use the official code-server image (proven to work)
FROM codercom/code-server:4.103.0

# Switch to root for installations
USER root

# Install Nginx and create required directories
RUN apt-get update && apt-get install -y nginx curl git socat

# Create workspace directories with proper ownership
RUN mkdir -p /home/coder/workspace-admin \
    /home/coder/workspace-mezzpro \
    /home/coder/nginx \
    && chown -R coder:coder /home/coder

# Set up nginx to run as coder user
RUN mkdir -p /var/log/nginx /var/cache/nginx /var/run \
    && chown -R coder:coder /var/log/nginx /var/cache/nginx /var/run \
    && touch /var/run/nginx.pid \
    && chown coder:coder /var/run/nginx.pid

# Copy configurations
COPY nginx.conf /home/coder/nginx/nginx.conf
COPY start.sh /home/coder/start.sh

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

# Start with our custom script
ENTRYPOINT ["/home/coder/start.sh"]
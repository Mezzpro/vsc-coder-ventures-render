# Use the official code-server image (proven to work)
FROM codercom/code-server:4.103.0

USER root

# Install Nginx for reverse proxy
RUN apt-get update && apt-get install -y nginx supervisor curl git

USER coder

# Apply VS Code settings for clean interface
COPY settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Create workspace directories
RUN mkdir -p /home/coder/workspace-admin
RUN mkdir -p /home/coder/workspace-mezzpro

# Copy configurations
COPY nginx.conf /tmp/nginx.conf
COPY start.sh /home/coder/start.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make scripts executable
RUN chmod +x /home/coder/start.sh

# Set default working directory
WORKDIR /home/coder

# Port configuration for Render
ENV PORT=10000

# Use start script as entrypoint
CMD ["/home/coder/start.sh"]
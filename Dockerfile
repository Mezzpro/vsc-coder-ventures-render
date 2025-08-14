# Use the official code-server image (proven to work)
FROM codercom/code-server:4.103.0

# Switch to root for installations
USER root

# Install Nginx for reverse proxy
RUN apt-get update && apt-get install -y nginx curl git

# Create workspace directories as root
RUN mkdir -p /home/coder/workspace-admin
RUN mkdir -p /home/coder/workspace-mezzpro

# Copy configurations and make executable
COPY nginx.conf /tmp/nginx.conf
COPY start.sh /home/coder/start.sh
RUN chmod +x /home/coder/start.sh
RUN chown coder:coder /home/coder/start.sh

# Switch back to coder user
USER coder

# Apply VS Code settings
COPY settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Set default working directory
WORKDIR /home/coder

# Port configuration for Render
ENV PORT=10000

# Start with our custom script
ENTRYPOINT ["/home/coder/start.sh"]
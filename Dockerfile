# Use the official code-server image (proven to work)
FROM codercom/code-server:4.103.0

# Switch to root for installations
USER root

# Install curl and git
RUN apt-get update && apt-get install -y curl git

# Create workspace directories with proper ownership
RUN mkdir -p /home/coder/workspace-admin \
    /home/coder/workspace-mezzpro \
    && chown -R coder:coder /home/coder

# Copy startup script and redirect page
COPY simple-start.sh /home/coder/start.sh
COPY workspace-redirect.html /home/coder/workspace-redirect.html

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
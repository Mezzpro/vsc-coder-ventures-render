# Use the official code-server image (proven to work)
FROM codercom/code-server:4.103.0

USER coder

# Apply VS Code settings for clean interface
COPY settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install essential packages
RUN sudo apt-get update && sudo apt-get install -y curl git

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Create workspace directory
RUN mkdir -p /home/coder/workspace

# Set default working directory
WORKDIR /home/coder/workspace

# Create welcome file
RUN echo "# 🚀 VSC Coder Ventures\n\nWelcome to your code-server environment!\n\n## Next Steps:\n1. This is working on Render\n2. We can add workspace configurations\n3. Then connect custom domains\n\n---\n*Testing on Render.com*" > /home/coder/workspace/README.md

# Port configuration for Render
ENV PORT=10000

# Start code-server
CMD ["dumb-init", "fixuid", "-q", "/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:10000", "--auth", "password", "/home/coder/workspace"]
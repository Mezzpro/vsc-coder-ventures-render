#!/bin/bash

echo "🚀 Starting VSC Multi-Domain Reverse Proxy..."

# Create workspace content
echo "📁 Creating workspace content..."

# Admin workspace content
cat > /home/coder/workspace-admin/README.md <<'EOF'
# 🏢 VSC Admin Panel

Welcome to the VSC Coder Ventures administrative workspace.

## Admin Features
- System management and monitoring
- Workspace configuration
- Default VS Code environment

## Current Setup
- **Domain**: cradlesystems.xyz
- **Theme**: Default Dark+
- **Environment**: Administrative

## Quick Start
This is your admin workspace for managing VSC Coder Ventures.

---
*VSC Coder Ventures - Admin Panel*
EOF

# MezzPro workspace content
cat > /home/coder/workspace-mezzpro/README.md <<'EOF'
# ⛓️ MezzPro Blockchain Platform

Welcome to your dedicated blockchain development environment!

## Platform Features
- **Dark Theme**: Optimized for blockchain development
- **Crypto Focus**: Smart contract development tools
- **Professional Setup**: Everything for blockchain projects

## Development Environment
- **Domain**: mezzpro.xyz  
- **Theme**: Dark blockchain theme
- **Font**: JetBrains Mono with ligatures

## Quick Start
Start building your blockchain projects here!

---
*MezzPro Blockchain Platform - Professional Development*
EOF

# Create project directories
mkdir -p /home/coder/workspace-admin/projects
mkdir -p /home/coder/workspace-mezzpro/smart-contracts
mkdir -p /home/coder/workspace-mezzpro/dapps

# Setup Nginx configuration
echo "⚙️ Configuring Nginx..."
sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf

# Start code-server in background on port 8080
echo "📋 Starting code-server on port 8080..."
code-server \
    --bind-addr "0.0.0.0:8080" \
    --auth password \
    --disable-telemetry \
    --disable-update-check \
    /home/coder &

# Wait for code-server to start
echo "⏳ Waiting for code-server to initialize..."
sleep 15

# Test code-server is running
if curl -s -o /dev/null http://127.0.0.1:8080; then
    echo "✅ Code-server is running on port 8080"
else
    echo "❌ Code-server failed to start"
    exit 1
fi

# Start nginx in foreground on port 10000 (Render's port)
echo "🌐 Starting Nginx reverse proxy on port ${PORT:-10000}..."
echo "🔗 Domain routing:"
echo "   - cradlesystems.xyz → Admin workspace"
echo "   - mezzpro.xyz → MezzPro blockchain workspace"

exec sudo nginx -g "daemon off;"
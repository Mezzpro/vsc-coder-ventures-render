#!/bin/bash

echo "🚀 Starting VSC Coder Ventures with HTTP Proxy..."

# Create workspace content (same as before)
echo "📁 Setting up workspaces..."

# Admin workspace content
cat > /home/coder/workspace-admin/README.md <<'EOF'
# 🏢 VSC Admin Panel

Welcome to the VSC Coder Ventures administrative workspace.

## Current Setup
- **Domain**: cradlesystems.xyz
- **Theme**: Default Dark+
- **Environment**: Administrative

---
*VSC Coder Ventures - Admin Panel*
EOF

# MezzPro workspace content
cat > /home/coder/workspace-mezzpro/README.md <<'EOF'
# ⛓️ MezzPro Blockchain Platform

Welcome to your dedicated blockchain development environment!

## Platform Features
- **Matrix-style interface**: Green-on-black terminal aesthetic
- **Crypto Focus**: Smart contract development tools
- **Professional Setup**: Everything for blockchain projects

## Development Environment
- **Domain**: mezzpro.xyz  
- **Theme**: Matrix hacker theme
- **Font**: Courier New with terminal styling

---
*MezzPro Blockchain Platform*
EOF

# Create project directories
mkdir -p /home/coder/workspace-admin/projects
mkdir -p /home/coder/workspace-mezzpro/smart-contracts
mkdir -p /home/coder/workspace-mezzpro/dapps

# Apply Matrix theme settings to MezzPro workspace (hidden from users)
mkdir -p /home/coder/workspace-mezzpro/.vscode


# Apply admin theme settings (hidden from users)
mkdir -p /home/coder/workspace-admin/.vscode


# Make .vscode folders less visible
chmod 700 /home/coder/workspace-mezzpro/.vscode
chmod 700 /home/coder/workspace-admin/.vscode

echo "✅ Workspaces ready!"

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
cd /home/coder
npm install --production



# Start code-server in background on port 8080
echo "📋 Starting code-server on port 8080..."
unset PORT  # Don't let code-server use PORT env var
code-server \
    --bind-addr "0.0.0.0:8080" \
    --auth password \
    --disable-telemetry \
    --disable-update-check \
    /home/coder &

CODE_SERVER_PID=$!
echo "✅ Code-server started (PID: $CODE_SERVER_PID)"

# Wait for code-server to be ready
echo "⏳ Waiting for code-server to start..."
for i in {1..60}; do
    if curl -s -o /dev/null http://localhost:8080; then
        echo "✅ Code-server is ready!"
        break
    fi
    if [ $i -eq 60 ]; then
        echo "❌ Code-server failed to start within 60 seconds"
        exit 1
    fi
    sleep 1
done

# Start HTTP proxy server on port 10000 (Render's PORT)
echo "🌐 Starting HTTP Proxy on port ${PORT:-10000}..."
echo "🔗 Proxy will route requests to code-server on port 8080"

# Restore PORT for proxy
export PORT=${PORT:-10000}

# Start the proxy server in foreground (main process)
exec node /home/coder/proxy-server.js

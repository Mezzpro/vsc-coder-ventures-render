#!/bin/bash

echo "🚀 Starting VSC Coder Ventures with HTTP Proxy..."

# Create workspace directories
echo "📁 Setting up workspaces..."

# Create workspace directories (only what's needed for functionality)
mkdir -p /home/coder/workspace-admin
mkdir -p /home/coder/workspace-mezzpro

# Create .vscode directories and extract settings from workspace files
mkdir -p /home/coder/workspace-admin/.vscode
mkdir -p /home/coder/workspace-mezzpro/.vscode

# Extract settings from workspace files and apply them to folders
echo "🎨 Applying workspace-specific themes and settings..."

# Extract settings from cradle-admin workspace using jq
if command -v jq >/dev/null 2>&1; then
    jq '.settings' /home/coder/workspaces/cradle-admin.code-workspace > /home/coder/workspace-admin/.vscode/settings.json
    jq '.settings' /home/coder/workspaces/mezzpro.code-workspace > /home/coder/workspace-mezzpro/.vscode/settings.json
    echo "✅ Workspace settings applied via jq"
else
    # Fallback: Use node to extract settings
    node -e "
    const fs = require('fs');
    
    // Extract cradle admin settings
    const cradleWs = JSON.parse(fs.readFileSync('/home/coder/workspaces/cradle-admin.code-workspace', 'utf8'));
    fs.writeFileSync('/home/coder/workspace-admin/.vscode/settings.json', JSON.stringify(cradleWs.settings, null, 2));
    
    // Extract mezzpro settings  
    const mezzproWs = JSON.parse(fs.readFileSync('/home/coder/workspaces/mezzpro.code-workspace', 'utf8'));
    fs.writeFileSync('/home/coder/workspace-mezzpro/.vscode/settings.json', JSON.stringify(mezzproWs.settings, null, 2));
    
    console.log('✅ Workspace settings applied via node');
    "
fi

# Hide .vscode folders from user view
chmod 700 /home/coder/workspace-admin/.vscode
chmod 700 /home/coder/workspace-mezzpro/.vscode

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

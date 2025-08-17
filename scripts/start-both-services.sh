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

# Apply workspace-specific themes using dedicated scripts
echo "🎨 Applying workspace-specific themes..."

# Apply MezzPro theme
bash /home/coder/scripts/themes/apply-mezzpro-theme.sh

# Apply Cradle theme  
bash /home/coder/scripts/themes/apply-cradle-theme.sh

# Create business content for MezzPro
bash /home/coder/scripts/content/create-mezzpro-business.sh

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

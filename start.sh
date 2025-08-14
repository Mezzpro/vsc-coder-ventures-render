#!/bin/bash

echo "🚀 Starting VSC Multi-Domain Reverse Proxy..."

# Function for fallback
fallback_start() {
    echo "⚠️ Falling back to basic code-server..."
    exec code-server --bind-addr "0.0.0.0:${PORT:-10000}" --auth password --disable-telemetry /home/coder/workspace
}

# Try to setup multi-domain routing
setup_multi_domain() {
    # Create workspace content
    echo "📁 Creating workspace content..."

    # Admin workspace content
    mkdir -p /home/coder/workspace-admin
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

---
*VSC Coder Ventures - Admin Panel*
EOF

    # MezzPro workspace content
    mkdir -p /home/coder/workspace-mezzpro
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

---
*MezzPro Blockchain Platform - Professional Development*
EOF

    # Create project directories
    mkdir -p /home/coder/workspace-admin/projects
    mkdir -p /home/coder/workspace-mezzpro/smart-contracts

    # Setup Nginx configuration
    echo "⚙️ Configuring Nginx..."
    if ! sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf; then
        echo "❌ Nginx configuration failed"
        return 1
    fi

    # Start code-server in background
    echo "📋 Starting code-server on port 8080..."
    code-server --bind-addr "0.0.0.0:8080" --auth password --disable-telemetry /home/coder &
    CODE_SERVER_PID=$!

    # Wait for code-server
    echo "⏳ Waiting for code-server..."
    sleep 10

    # Check if code-server started
    if ! curl -s -o /dev/null http://127.0.0.1:8080; then
        echo "❌ Code-server failed to start"
        kill $CODE_SERVER_PID 2>/dev/null
        return 1
    fi

    echo "✅ Code-server is running on port 8080"

    # Start nginx
    echo "🌐 Starting Nginx reverse proxy..."
    echo "🔗 Domain routing:"
    echo "   - cradlesystems.xyz → Admin workspace"
    echo "   - mezzpro.xyz → MezzPro blockchain workspace"
    
    if ! sudo nginx -g "daemon off;"; then
        echo "❌ Nginx failed to start"
        kill $CODE_SERVER_PID 2>/dev/null
        return 1
    fi
}

# Try multi-domain setup, fallback if it fails
if ! setup_multi_domain; then
    echo "⚠️ Multi-domain setup failed, using fallback..."
    fallback_start
fi
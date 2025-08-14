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

## Quick Start
Start building your blockchain projects with this Matrix-inspired setup!

---
*MezzPro Blockchain Platform - Professional Development*
EOF

    # Create project directories
    mkdir -p /home/coder/workspace-admin/projects
    mkdir -p /home/coder/workspace-mezzpro/smart-contracts
    mkdir -p /home/coder/workspace-mezzpro/dapps

    # Apply Matrix theme settings to MezzPro workspace (hidden from users)
    mkdir -p /home/coder/workspace-mezzpro/.vscode
    cat > /home/coder/workspace-mezzpro/.vscode/settings.json <<'EOF'
{
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": "vs-minimal",
  "window.title": "MezzPro Blockchain Platform - Matrix Terminal",
  "editor.fontSize": 14,
  "editor.fontFamily": "'Courier New', 'Lucida Console', 'Monaco', monospace",
  "editor.fontWeight": "bold",
  "editor.cursorBlinking": "expand",
  "editor.cursorStyle": "block",
  "editor.cursorWidth": 4,
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "'Courier New', monospace",
  "terminal.integrated.fontWeight": "bold",
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.cursorStyle": "block",
  "workbench.colorCustomizations": {
    "editor.background": "#000000",
    "editor.foreground": "#00ff41",
    "editorCursor.foreground": "#00ff41",
    "editor.selectionBackground": "#003300",
    "editor.lineHighlightBackground": "#001100",
    "sideBar.background": "#0a0a0a",
    "sideBar.foreground": "#00cc33",
    "activityBar.background": "#050505",
    "activityBar.foreground": "#00ff41",
    "statusBar.background": "#000000",
    "statusBar.foreground": "#00ff41",
    "terminal.background": "#000000",
    "terminal.foreground": "#00ff41",
    "tab.activeBackground": "#001100",
    "tab.activeForeground": "#00ff41"
  },
  "files.exclude": {
    "**/.vscode": true,
    "**/*.code-workspace": true
  },
  "explorer.fileNesting.enabled": true,
  "files.autoSave": "onFocusChange",
  "workbench.startupEditor": "readme",
  "git.autofetch": true
}
EOF

    # Make .vscode folder hidden from file explorer
    chmod 700 /home/coder/workspace-mezzpro/.vscode

    # Create nginx temp directories
    mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp

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

    # Start nginx (running as coder user, no sudo needed)
    echo "🌐 Starting Nginx reverse proxy..."
    echo "🔗 Domain routing:"
    echo "   - cradlesystems.xyz → Admin workspace"
    echo "   - mezzpro.xyz → MezzPro workspace"
    
    if ! nginx -c /home/coder/nginx/nginx.conf -g "daemon off;"; then
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
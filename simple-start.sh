#!/bin/bash

echo "🚀 Starting VSC Coder Ventures..."

# Create workspace content
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
cat > /home/coder/workspace-mezzpro/.vscode/settings.json <<'EOF'
{
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": "vs-minimal",
  "window.title": "MezzPro Blockchain Platform",
  "editor.fontSize": 14,
  "editor.fontFamily": "'Courier New', 'Lucida Console', 'Monaco', monospace",
  "editor.fontWeight": "bold",
  "editor.cursorBlinking": "expand",
  "editor.cursorStyle": "block",
  "editor.cursorWidth": 4,
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "'Courier New', monospace",
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
    "tab.activeForeground": "#00ff41",
    "tab.inactiveBackground": "#000000",
    "tab.inactiveForeground": "#009922"
  },
  "files.exclude": {
    "**/.vscode": true,
    "**/*.code-workspace": true
  },
  "explorer.excludeGitIgnore": false,
  "files.autoSave": "onFocusChange",
  "workbench.startupEditor": "readme",
  "git.autofetch": true
}
EOF

# Apply admin theme settings (hidden from users)
mkdir -p /home/coder/workspace-admin/.vscode
cat > /home/coder/workspace-admin/.vscode/settings.json <<'EOF'
{
  "workbench.colorTheme": "Default Dark+",
  "window.title": "VSC Admin Panel",
  "editor.fontSize": 14,
  "editor.fontFamily": "'Cascadia Code', 'Courier New', monospace",
  "files.exclude": {
    "**/.vscode": true,
    "**/*.code-workspace": true
  },
  "files.autoSave": "onFocusChange",
  "workbench.startupEditor": "readme"
}
EOF

# Make .vscode folders less visible
chmod 700 /home/coder/workspace-mezzpro/.vscode
chmod 700 /home/coder/workspace-admin/.vscode

echo "✅ Workspaces ready!"

# Detect which workspace to open based on HTTP_HOST or RENDER_EXTERNAL_URL
WORKSPACE_PATH="/home/coder/workspace"

# Check if we can detect the domain from environment
if [[ "$RENDER_EXTERNAL_URL" == *"mezzpro"* ]] || [[ "$HTTP_HOST" == *"mezzpro"* ]]; then
    WORKSPACE_PATH="/home/coder/workspace-mezzpro"
    echo "🔗 Loading MezzPro workspace..."
elif [[ "$RENDER_EXTERNAL_URL" == *"cradlesystems"* ]] || [[ "$HTTP_HOST" == *"cradlesystems"* ]]; then
    WORKSPACE_PATH="/home/coder/workspace-admin"
    echo "🏢 Loading Admin workspace..."
else
    # Create a default workspace with links to both
    mkdir -p /home/coder/workspace
    cat > /home/coder/workspace/README.md <<'EOF'
# 🚀 VSC Coder Ventures

## Select Your Workspace:

To access your workspace, append the folder parameter to the URL:

### MezzPro Blockchain Platform
Add to URL: `?folder=/home/coder/workspace-mezzpro`

### Admin Panel  
Add to URL: `?folder=/home/coder/workspace-admin`

---
*VSC Coder Ventures - Multi-Workspace Platform*
EOF
    echo "📁 Loading default workspace..."
fi

echo "📋 Starting code-server on port ${PORT:-10000}..."
echo "📂 Workspace: $WORKSPACE_PATH"

# Start code-server with the selected workspace
exec code-server \
    --bind-addr "0.0.0.0:${PORT:-10000}" \
    --auth password \
    --disable-telemetry \
    --disable-update-check \
    "$WORKSPACE_PATH"
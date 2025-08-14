#!/bin/bash

# VSC Domain Router - Routes domains to different workspaces
# This script detects the domain and starts code-server with appropriate workspace

echo "🚀 VSC Domain Router Starting..."

# Create workspace directories
mkdir -p /home/coder/workspace-admin
mkdir -p /home/coder/workspace-mezzpro  
mkdir -p /home/coder/workspace-minqro

# Create admin workspace content
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

# Create MezzPro workspace content
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

# Create Minqro workspace content
cat > /home/coder/workspace-minqro/README.md <<'EOF'
# ✨ Minqro Marketing Studio

Welcome to your creative marketing workspace!

## Studio Features
- **Light Theme**: Clean interface for content creation
- **Marketing Focus**: Content creation and campaign tools
- **Professional Design**: Optimized for marketing workflows

## Content Environment
- **Domain**: minqro.xyz
- **Theme**: Light marketing theme  
- **Font**: Clean, readable typography

## Quick Start
Start creating amazing marketing content!

---
*Minqro Marketing Studio - Creative Content Environment*
EOF

# Apply different VS Code settings based on domain
# Note: This is a simplified approach - in production you'd use HTTP headers
# For now, we'll use environment variables or create multiple services

# Default to admin workspace
WORKSPACE_DIR="/home/coder/workspace-admin"
WORKSPACE_NAME="Admin Panel"

# Check for workspace type environment variable
if [ "$WORKSPACE_TYPE" = "mezzpro" ]; then
    WORKSPACE_DIR="/home/coder/workspace-mezzpro" 
    WORKSPACE_NAME="MezzPro Blockchain"
    echo "🔗 Loading MezzPro Blockchain workspace..."
elif [ "$WORKSPACE_TYPE" = "minqro" ]; then
    WORKSPACE_DIR="/home/coder/workspace-minqro"
    WORKSPACE_NAME="Minqro Marketing"
    echo "🎨 Loading Minqro Marketing workspace..."
else
    echo "🏢 Loading Admin workspace..."
fi

echo "📁 Workspace: $WORKSPACE_NAME"
echo "📂 Directory: $WORKSPACE_DIR"
echo "🌐 Starting code-server on port ${PORT:-10000}..."

# Start code-server with selected workspace
exec code-server \
    --bind-addr "0.0.0.0:${PORT:-10000}" \
    --auth password \
    --disable-telemetry \
    --disable-update-check \
    "$WORKSPACE_DIR"
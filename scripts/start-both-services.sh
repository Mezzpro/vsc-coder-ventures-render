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

# Apply workspace-specific themes and settings directly
echo "🎨 Applying workspace-specific themes and settings..."

# Apply MezzPro Matrix theme settings
cat > /home/coder/workspace-mezzpro/.vscode/settings.json <<'EOF'
{
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": "vs-minimal",
  "workbench.activityBar.visible": true,
  "workbench.statusBar.visible": true,
  "workbench.sideBar.location": "left",
  "workbench.panel.defaultLocation": "top",
  "window.menuBarVisibility": "compact",
  "window.commandCenter": true,
  "editor.minimap.enabled": true,
  "editor.minimap.renderCharacters": false,
  "editor.minimap.maxColumn": 80,
  "editor.lineNumbers": "on",
  "editor.renderWhitespace": "boundary",
  "editor.renderLineHighlight": "all",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": "active",
  "editor.folding": true,
  "editor.glyphMargin": true,
  "breadcrumbs.enabled": true,
  "editor.fontSize": 14,
  "editor.fontFamily": "'Courier New', 'Lucida Console', 'Monaco', monospace",
  "editor.fontWeight": "bold",
  "editor.lineHeight": 1.4,
  "editor.letterSpacing": 0.8,
  "editor.cursorBlinking": "expand",
  "editor.cursorStyle": "block",
  "editor.cursorWidth": 4,
  "editor.smoothScrolling": true,
  "editor.cursorSmoothCaretAnimation": "on",
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "'Courier New', monospace",
  "terminal.integrated.fontWeight": "bold",
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.cursorStyle": "block",
  "debug.console.closeOnEnd": true,
  "debug.openDebug": "neverOpen", 
  "extensions.ignoreRecommendations": true,
  "git.decorations.enabled": false,
  "scm.diffDecorations": "none",
  "workbench.colorCustomizations": {
    "editor.background": "#000000",
    "editor.foreground": "#00ff41",
    "editorCursor.foreground": "#00ff41",
    "editor.selectionBackground": "#003300",
    "editor.lineHighlightBackground": "#001100",
    "editor.wordHighlightBackground": "#002200",
    "sideBar.background": "#0a0a0a",
    "sideBar.foreground": "#00cc33",
    "activityBar.background": "#050505",
    "activityBar.foreground": "#00ff41",
    "panel.background": "#000000",
    "panel.border": "#00ff41",
    "statusBar.background": "#000000",
    "statusBar.foreground": "#00ff41",
    "statusBar.border": "#00ff41",
    "titleBar.activeBackground": "#000000",
    "titleBar.activeForeground": "#00ff41",
    "tab.activeBackground": "#001100",
    "tab.activeForeground": "#00ff41",
    "tab.inactiveBackground": "#000000",
    "tab.inactiveForeground": "#009922",
    "tab.border": "#00ff41",
    "terminal.background": "#000000",
    "terminal.foreground": "#00ff41",
    "terminalCursor.background": "#00ff41",
    "terminalCursor.foreground": "#000000",
    "scrollbar.shadow": "#00ff41",
    "editorRuler.foreground": "#003300",
    "editorBracketMatch.background": "#006600",
    "editorBracketMatch.border": "#00ff41",
    "minimap.background": "#000000",
    "minimapSlider.background": "#003300",
    "minimapSlider.hoverBackground": "#006600"
  },
  "editor.tokenColorCustomizations": {
    "textMateRules": [
      {
        "scope": ["comment"],
        "settings": {
          "foreground": "#006600",
          "fontStyle": "italic"
        }
      },
      {
        "scope": ["string"],
        "settings": {
          "foreground": "#00cc33"
        }
      },
      {
        "scope": ["keyword", "storage.type"],
        "settings": {
          "foreground": "#00ff41",
          "fontStyle": "bold"
        }
      },
      {
        "scope": ["variable", "support.variable"],
        "settings": {
          "foreground": "#33ff66"
        }
      },
      {
        "scope": ["function", "entity.name.function"],
        "settings": {
          "foreground": "#66ff99",
          "fontStyle": "bold"
        }
      },
      {
        "scope": ["constant.numeric"],
        "settings": {
          "foreground": "#99ffcc"
        }
      }
    ]
  },
  "files.autoSave": "onFocusChange",
  "editor.formatOnSave": true,
  "editor.formatOnType": true,
  "editor.rulers": [80, 120],
  "editor.wordWrap": "bounded",
  "editor.wordWrapColumn": 120,
  "git.autofetch": true,
  "git.confirmSync": false,
  "git.enableSmartCommit": true,
  "workbench.startupEditor": "none",
  "telemetry.telemetryLevel": "off",
  "update.showReleaseNotes": false,
  "extensions.showRecommendationsOnlyOnDemand": true,
  "window.title": "MezzPro Blockchain Platform",
  "files.exclude": {
    "**/.vscode": true
  }
}
EOF

# Apply Cradle Admin clean theme settings
cat > /home/coder/workspace-admin/.vscode/settings.json <<'EOF'
{
  "workbench.colorTheme": "Default Light+",
  "workbench.iconTheme": null,
  "workbench.activityBar.visible": false,
  "workbench.statusBar.visible": false,
  "workbench.sideBar.location": "left",
  "workbench.panel.defaultLocation": "bottom",
  "workbench.panel.opensMaximized": "never",
  "window.menuBarVisibility": "toggle",
  "window.commandCenter": false,
  "explorer.openEditors.visible": 0,
  "explorer.decorations.badges": false,
  "explorer.decorations.colors": false,
  "workbench.view.extensions.state.hidden": true,
  "workbench.view.extension.workspaceConfigPlus.state.hidden": true,
  "editor.minimap.enabled": false,
  "editor.lineNumbers": "off",
  "editor.renderWhitespace": "none",
  "editor.renderLineHighlight": "none",
  "editor.occurrencesHighlight": false,
  "editor.folding": false,
  "editor.glyphMargin": false,
  "editor.renderIndentGuides": false,
  "breadcrumbs.enabled": false,
  "editor.scrollbar.horizontal": "hidden",
  "editor.scrollbar.vertical": "hidden",
  "editor.overviewRulerBorder": false,
  "editor.fontSize": 20,
  "editor.fontFamily": "'SF Pro Display', 'Segoe UI', system-ui, sans-serif",
  "editor.fontWeight": "300",
  "editor.lineHeight": 1.8,
  "editor.letterSpacing": 0.5,
  "workbench.editor.showTabs": "none",
  "zenMode.centerLayout": true,
  "zenMode.hideLineNumbers": true,
  "zenMode.hideTabs": true,
  "zenMode.hideStatusBar": true,
  "zenMode.hideActivityBar": true,
  "zenMode.fullScreen": false,
  "editor.cursorBlinking": "solid",
  "editor.cursorStyle": "block",
  "editor.cursorWidth": 2,
  "editor.smoothScrolling": false,
  "terminal.integrated.fontSize": 16,
  "terminal.integrated.fontFamily": "'SF Mono', Consolas, monospace",
  "terminal.integrated.tabs.enabled": false,
  "debug.console.closeOnEnd": true,
  "debug.openDebug": "neverOpen",
  "extensions.ignoreRecommendations": true,
  "git.openRepositoryInParentFolders": "never",
  "scm.diffDecorations": "none",
  "workbench.colorCustomizations": {
    "editor.background": "#ffffff",
    "editor.foreground": "#2c2c2c",
    "editorCursor.foreground": "#2c2c2c",
    "editor.selectionBackground": "#e8e8e8",
    "editor.lineHighlightBackground": "#fafafa",
    "sideBar.background": "#f8f8f8",
    "activityBar.background": "#f0f0f0",
    "panel.background": "#f8f8f8",
    "statusBar.background": "#f0f0f0",
    "titleBar.activeBackground": "#ffffff",
    "tab.activeBackground": "#ffffff",
    "tab.inactiveBackground": "#f8f8f8"
  },
  "editor.tokenColorCustomizations": {
    "textMateRules": [
      {
        "scope": ["comment"],
        "settings": {
          "foreground": "#999999",
          "fontStyle": "italic"
        }
      },
      {
        "scope": ["string", "keyword", "variable", "function", "class"],
        "settings": {
          "foreground": "#2c2c2c"
        }
      }
    ]
  },
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 2000,
  "editor.formatOnSave": true,
  "editor.wordWrap": "on",
  "workbench.startupEditor": "none",
  "workbench.tips.enabled": false,
  "workbench.welcomePage.walkthroughs.openOnInstall": false,
  "workbench.editor.enablePreview": false,
  "workbench.editor.enablePreviewFromQuickOpen": false,
  "telemetry.telemetryLevel": "off",
  "update.showReleaseNotes": false,
  "extensions.showRecommendationsOnlyOnDemand": true,
  "extensions.ignoreRecommendations": true,
  "terminal.integrated.showExitAlert": false,
  "workbench.panel.opens": "never",
  "window.title": "Cradle Systems Admin Panel",
  "window.titleSeparator": " • ",
  "workbench.view.extensions.state.hidden": true,
  "workbench.activityBar.iconClickBehavior": "hide",
  "problems.visibility": false,
  "files.exclude": {
    "**/.vscode": true
  }
}
EOF

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

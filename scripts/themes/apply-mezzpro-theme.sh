#!/bin/bash

# MezzPro Matrix Theme Application
echo "🎨 Applying MezzPro Matrix theme..."

cat > /home/coder/workspace-mezzpro/.vscode/settings.json <<'EOF'
{
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": null,
  "workbench.activityBar.visible": false,
  "workbench.statusBar.visible": false,
  "workbench.sideBar.location": "left",
  "workbench.panel.defaultLocation": "right",
  "window.menuBarVisibility": "hidden",
  "window.commandCenter": false,
  "editor.minimap.enabled": false,
  "editor.lineNumbers": "off",
  "editor.renderWhitespace": "none",
  "editor.renderLineHighlight": "none",
  "editor.bracketPairColorization.enabled": false,
  "editor.guides.bracketPairs": false,
  "editor.folding": false,
  "editor.glyphMargin": false,
  "breadcrumbs.enabled": false,
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
  "workbench.editor.showTabs": "single",
  "workbench.editor.enablePreview": true,
  "workbench.editor.enablePreviewFromQuickOpen": true,
  "explorer.openEditors.visible": 0,
  "explorer.decorations.badges": false,
  "explorer.decorations.colors": false,
  "outline.showFiles": false,
  "outline.showModules": false,
  "outline.showNamespaces": false,
  "outline.showPackages": false,
  "outline.showClasses": false,
  "outline.showMethods": false,
  "outline.showProperties": false,
  "outline.showFields": false,
  "outline.showConstructors": false,
  "outline.showEnums": false,
  "outline.showInterfaces": false,
  "outline.showFunctions": false,
  "outline.showVariables": false,
  "outline.showConstants": false,
  "outline.showStrings": false,
  "outline.showNumbers": false,
  "outline.showBooleans": false,
  "outline.showArrays": false,
  "outline.showObjects": false,
  "outline.showKeys": false,
  "outline.showNull": false,
  "timeline.showView": false,
  "scm.showChangesSummary": false,
  "problems.visibility": false,
  "workbench.view.search.state.hidden": true,
  "workbench.view.extensions.state.hidden": true,
  "workbench.view.debug.state.hidden": true,
  "workbench.view.remote.state.hidden": true,
  "workbench.sideBar.visible": false,
  "workbench.panel.opensMaximized": "never",
  "workbench.editor.limit.enabled": true,
  "workbench.editor.limit.value": 3,
  "workbench.editor.limit.perEditorGroup": true,
  "files.exclude": {
    "**/.vscode": true,
    "**/.git": true,
    "**/node_modules": true
  },
  "workbench.editorAssociations": {
    "*.html": "default",
    "*.md": "vscode.markdown.preview.editor"
  },
  "html.autoClosingTags": true,
  "workbench.editor.enablePreview": true,
  "workbench.editor.enablePreviewFromQuickOpen": true,
  "workbench.startupEditor": "none",
  "workbench.editor.showTabs": "multiple",
  "workbench.editor.tabSizing": "fit",
  "extensions.autoInstall": ["lyne-inc.html-speed-viewer"],
  "htmlspeedviewer.enableAutoRefresh": true,
  "htmlspeedviewer.showInTab": true,
  "htmlspeedviewer.openInPreview": true,
  "workbench.editor.chat.enabled": true,
  "workbench.editor.processExplorer.enabled": true,
  "workbench.editor.terminalEditor.enabled": true,
  "workbench.editor.imagePreview.enabled": true,
  "workbench.editor.audioPreview.enabled": true,
  "workbench.editor.videoPreview.enabled": true,
  "workbench.editor.markdownPreview.enabled": true,
  "workbench.editor.simpleBrowser.enabled": true,
  "workbench.editor.livePreview.enabled": true,
  "livePreview.autoRefreshPreview": "On Changes to Saved Files",
  "livePreview.showServerStatusNotifications": false,
  "html.suggest.html5": false,
  "emmet.showExpandedAbbreviation": "never",
  "html.format.enable": false,
  "html.validate.scripts": false,
  "html.validate.styles": false
}
EOF

# Install HTML Speed Viewer extension
echo "📦 Installing HTML Speed Viewer extension..."
code-server --install-extension lyne-inc.html-speed-viewer --force

# Install Live Preview extension
echo "📦 Installing Live Preview extension..."
code-server --install-extension ms-vscode.live-server --force

echo "✅ MezzPro Matrix theme applied"
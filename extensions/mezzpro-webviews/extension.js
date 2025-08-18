const vscode = require('vscode');
const path = require('path');
const fs = require('fs');

// Simple webview panels tracker
let webviewPanels = {};

function activate(context) {
    const workspaceFolder = vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders.length > 0
        ? vscode.workspace.workspaceFolders[0].uri.fsPath
        : '';

    // Only activate in MezzPro workspace
    if (!workspaceFolder.includes('workspace-mezzpro')) {
        console.log('Not in MezzPro workspace, extension not activated');
        return;
    }

    console.log('MezzPro Webviews extension activated');

    // Register commands for each business section
    context.subscriptions.push(
        vscode.commands.registerCommand('mezzpro.openDashboard', () => {
            openBusinessSection('dashboard', 'Dashboard', 'Dashboard.html', context.extensionUri);
        })
    );

    context.subscriptions.push(
        vscode.commands.registerCommand('mezzpro.openPricing', () => {
            openBusinessSection('pricing', 'Pricing', 'Pricing.html', context.extensionUri);
        })
    );

    context.subscriptions.push(
        vscode.commands.registerCommand('mezzpro.openAnalytics', () => {
            openBusinessSection('analytics', 'Analytics', 'Analytics.html', context.extensionUri);
        })
    );

    context.subscriptions.push(
        vscode.commands.registerCommand('mezzpro.openTools', () => {
            openBusinessSection('tools', 'Tools', 'Tools.html', context.extensionUri);
        })
    );

    context.subscriptions.push(
        vscode.commands.registerCommand('mezzpro.openAllSections', () => {
            openBusinessSection('dashboard', 'Dashboard', 'Dashboard.html', context.extensionUri, vscode.ViewColumn.One);
            setTimeout(() => openBusinessSection('pricing', 'Pricing', 'Pricing.html', context.extensionUri, vscode.ViewColumn.Two), 100);
            setTimeout(() => openBusinessSection('analytics', 'Analytics', 'Analytics.html', context.extensionUri, vscode.ViewColumn.Three), 200);
            setTimeout(() => openBusinessSection('tools', 'Tools', 'Tools.html', context.extensionUri, vscode.ViewColumn.Four), 300);
        })
    );
}

function openBusinessSection(sectionId, title, filename, extensionUri, column = vscode.ViewColumn.Active) {
    // If webview already exists, just show it
    if (webviewPanels[sectionId]) {
        webviewPanels[sectionId].reveal(column);
        return;
    }

    // Create new webview panel
    const panel = vscode.window.createWebviewPanel(
        sectionId,
        title,
        column,
        {
            enableScripts: true,
            localResourceRoots: [
                vscode.Uri.joinPath(extensionUri, '..', '..', '..'),
                vscode.workspace.workspaceFolders[0].uri
            ]
        }
    );

    // Load HTML content
    const workspaceRoot = vscode.workspace.workspaceFolders[0].uri.fsPath;
    const htmlPath = path.join(workspaceRoot, filename);
    
    try {
        const htmlContent = fs.readFileSync(htmlPath, 'utf8');
        panel.webview.html = processHtmlContent(htmlContent, panel.webview, workspaceRoot);
    } catch (error) {
        panel.webview.html = getErrorHtml(title, `Could not load ${filename}: ${error.message}`);
    }

    // Store panel reference
    webviewPanels[sectionId] = panel;

    // Clean up when panel is disposed
    panel.onDidDispose(() => {
        delete webviewPanels[sectionId];
    });

    // Set up file watcher for live updates
    const watcher = vscode.workspace.createFileSystemWatcher(
        new vscode.RelativePattern(workspaceRoot, filename)
    );

    watcher.onDidChange(() => {
        try {
            const updatedContent = fs.readFileSync(htmlPath, 'utf8');
            panel.webview.html = processHtmlContent(updatedContent, panel.webview, workspaceRoot);
        } catch (error) {
            console.error(`Error updating ${filename}:`, error);
        }
    });

    panel.onDidDispose(() => {
        watcher.dispose();
    });
}

function processHtmlContent(htmlContent, webview, workspaceRoot) {
    // Convert relative paths to webview URIs
    const processedContent = htmlContent.replace(
        /(href|src)="([^"]*\.(css|js|png|jpg|jpeg|gif|svg))"/g,
        (match, attr, relativePath) => {
            const absolutePath = path.join(workspaceRoot, relativePath);
            const webviewUri = webview.asWebviewUri(vscode.Uri.file(absolutePath));
            return `${attr}="${webviewUri}"`;
        }
    );

    // Add meta tags for better webview rendering
    const enhancedContent = processedContent.replace(
        '<head>',
        `<head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src ${webview.cspSource} 'unsafe-inline'; script-src ${webview.cspSource} 'unsafe-inline'; img-src ${webview.cspSource} data: https:;">`
    );

    return enhancedContent;
}

function getErrorHtml(title, errorMessage) {
    return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} - Error</title>
    <style>
        body {
            background: #000000;
            color: #00ff41;
            font-family: 'Courier New', monospace;
            padding: 20px;
            text-align: center;
        }
        .error {
            border: 1px solid #ff4444;
            padding: 20px;
            border-radius: 8px;
            background: #330000;
            color: #ff6666;
        }
    </style>
</head>
<body>
    <h1>${title}</h1>
    <div class="error">
        <h2>Error Loading Content</h2>
        <p>${errorMessage}</p>
        <p>Please ensure the HTML file exists in the workspace.</p>
    </div>
</body>
</html>`;
}

function deactivate() {
    // Clean up webview panels
    Object.keys(webviewPanels).forEach(key => {
        if (webviewPanels[key]) {
            webviewPanels[key].dispose();
        }
    });
    webviewPanels = {};
}

module.exports = {
    activate,
    deactivate
};
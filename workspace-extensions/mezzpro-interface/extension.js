const vscode = require('vscode');

// 1. Activate function - entry point
function activate(context) {
    const workspaceFolder = vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders.length > 0
        ? vscode.workspace.workspaceFolders[0].uri.fsPath
        : '';

    // Only activate the MezzPro UI if we are in the mezzpro workspace
    if (workspaceFolder.includes('workspace-mezzpro')) {
        console.log('Activating MezzPro Interface for workspace:', workspaceFolder);

        // Register the Sidebar provider
        const sidebarProvider = new MezzProSidebarProvider(context.extensionUri);
        context.subscriptions.push(
            vscode.window.registerWebviewViewProvider("mezzpro.navigationView", sidebarProvider)
        );

        // Register the command to show a page
        context.subscriptions.push(
            vscode.commands.registerCommand('mezzpro.showPage', (page) => {
                MezzProPanel.createOrShow(context.extensionUri, page);
            })
        );

        // Move terminal to the right, and open the MezzPro sidebar
        vscode.commands.executeCommand('workbench.action.terminal.focus');
        vscode.commands.executeCommand('workbench.action.movePanelToSecondarySideBar').then(() => {
            // Only show the aux bar if it's not already visible
            vscode.commands.executeCommand('workbench.action.view.toggleAuxiliaryBar');
        });
        vscode.commands.executeCommand('mezzpro.navigationView.focus');

    } else {
        console.log('Not in MezzPro workspace, MezzPro Interface not activated. Workspace:', workspaceFolder);
    }
}

// 5. Sidebar Webview Provider
class MezzProSidebarProvider {
    constructor(extensionUri) {
        this._extensionUri = extensionUri;
    }

    resolveWebviewView(webviewView, context, _token) {
        this._view = webviewView;

        webviewView.webview.options = {
            enableScripts: true,
            localResourceRoots: [vscode.Uri.joinPath(this._extensionUri, 'media')]
        };

        webviewView.webview.html = this._getHtmlForSidebar(webviewView.webview);

        webviewView.webview.onDidReceiveMessage(data => {
            if (data.command) {
                vscode.commands.executeCommand(data.command, data.page);
            }
        });
    }

    _getHtmlForSidebar(webview) {
        const scriptUri = webview.asWebviewUri(vscode.Uri.joinPath(this._extensionUri, 'media', 'sidebar.js'));
        const styleUri = webview.asWebviewUri(vscode.Uri.joinPath(this._extensionUri, 'media', 'sidebar.css'));
        const nonce = getNonce();

        return `<!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src ${webview.cspSource}; script-src 'nonce-${nonce}';">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>MezzPro Navigation</title>
                <link href="${styleUri}" rel="stylesheet" />
            </head>
            <body>
                <h1>MezzPro</h1>
                <ul>
                    <li data-page="home">Home</li>
                    <li data-page="dashboard">Dashboard</li>
                    <li data-page="contracts">Smart Contracts</li>
                    <li data-page="analytics">Analytics</li>
                </ul>
                <script nonce="${nonce}" src="${scriptUri}"></script>
            </body>
            </html>`;
    }
}

// 6. Main Panel Webview
class MezzProPanel {
    static currentPanel = undefined;
    static viewType = 'mezzProPage';

    static createOrShow(extensionUri, page) {
        const column = vscode.window.activeTextEditor
            ? vscode.window.activeTextEditor.viewColumn
            : undefined;

        if (MezzProPanel.currentPanel) {
            MezzProPanel.currentPanel._panel.reveal(column);
            MezzProPanel.currentPanel._update(page);
            return;
        }

        const panel = vscode.window.createWebviewPanel(
            MezzProPanel.viewType,
            'MezzPro',
            column || vscode.ViewColumn.One,
            {
                enableScripts: true,
                localResourceRoots: [vscode.Uri.joinPath(extensionUri, 'media')]
            }
        );

        MezzProPanel.currentPanel = new MezzProPanel(panel, extensionUri, page);
    }

    constructor(panel, extensionUri, page) {
        this._panel = panel;
        this._extensionUri = extensionUri;

        this._update(page);

        this._panel.onDidDispose(() => this.dispose(), null, []);
    }

    _update(page) {
        const webview = this._panel.webview;
        this._panel.title = `MezzPro - ${page.charAt(0).toUpperCase() + page.slice(1)}`;
        webview.html = this._getHtmlForWebview(webview, page);
    }

    dispose() {
        MezzProPanel.currentPanel = undefined;
        this._panel.dispose();
    }

    _getHtmlForWebview(webview, page) {
        // For now, a simple placeholder. We can create separate html files later.
        return `<!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>MezzPro</title>
            </head>
            <body>
                <h1>Welcome to the ${page.charAt(0).toUpperCase() + page.slice(1)} Page</h1>
                <p>This is the content for the ${page} section.</p>
            </body>
            </html>`;
    }
}

function getNonce() {
    let text = '';
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    for (let i = 0; i < 32; i++) {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    return text;
}


function deactivate() {}

module.exports = {
    activate,
    deactivate
};
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const app = express();

// Domain to workspace mapping
const DOMAIN_WORKSPACE_MAP = {
    'mezzpro.xyz': '/home/coder/workspace-mezzpro',
    'www.mezzpro.xyz': '/home/coder/workspace-mezzpro',
    'cradlesystems.xyz': '/home/coder/workspace-admin',
    'www.cradlesystems.xyz': '/home/coder/workspace-admin',
    'minqro.xyz': '/home/coder/workspace-minqro',
    'www.minqro.xyz': '/home/coder/workspace-minqro'
};

// Default workspace for unknown domains
const DEFAULT_WORKSPACE = '/home/coder/workspace-admin';

// Code-server runs on port 8080
const CODE_SERVER_PORT = 8080;

// Middleware to handle domain-based redirects
app.use('/', (req, res, next) => {
    const hostname = req.get('host') || '';
    const folderParam = req.query.folder;
    
    console.log(`🌐 Request: ${hostname}${req.url}`);
    console.log(`📂 Current folder param: ${folderParam || 'none'}`);
    
    // If folder parameter already exists, just proxy to code-server
    if (folderParam) {
        console.log(`✅ Folder param exists, proxying to code-server`);
        return next();
    }
    
    // Get workspace for current domain
    const targetWorkspace = DOMAIN_WORKSPACE_MAP[hostname.toLowerCase()] || DEFAULT_WORKSPACE;
    
    // Build redirect URL with folder parameter
    const redirectUrl = `${req.protocol}://${hostname}${req.path}?folder=${encodeURIComponent(targetWorkspace)}`;
    
    console.log(`🔄 Redirecting ${hostname} → ${targetWorkspace}`);
    console.log(`📍 Redirect URL: ${redirectUrl}`);
    
    // Issue HTTP 302 redirect
    return res.redirect(302, redirectUrl);
});

// Proxy all requests to code-server
const proxyOptions = {
    target: `http://127.0.0.1:${CODE_SERVER_PORT}`,
    changeOrigin: true,
    ws: true, // Enable WebSocket proxying for VS Code
    logLevel: 'info',
    onError: (err, req, res) => {
        console.error('❌ Proxy error:', err.message);
        res.status(500).send('Code-server proxy error');
    },
    onProxyReq: (proxyReq, req, res) => {
        console.log(`🔄 Proxying: ${req.method} ${req.url} → code-server`);
    },
    onProxyRes: (proxyRes, req, res) => {
        console.log(`✅ Code-server response: ${proxyRes.statusCode} for ${req.url}`);
    }
};

// Create proxy middleware
const proxy = createProxyMiddleware(proxyOptions);
app.use('/', proxy);

// Start proxy server
const PORT = process.env.PORT || 10000;
const server = app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 VSC Proxy Server running on port ${PORT}`);
    console.log(`🔗 Code-server target: http://localhost:${CODE_SERVER_PORT}`);
    console.log(`🌐 Domain mappings:`);
    Object.entries(DOMAIN_WORKSPACE_MAP).forEach(([domain, workspace]) => {
        console.log(`   ${domain} → ${workspace}`);
    });
});

// Handle WebSocket upgrades for VS Code
server.on('upgrade', (request, socket, head) => {
    console.log('🔌 WebSocket upgrade request');
    proxy.upgrade(request, socket, head);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('🛑 Received SIGTERM, shutting down gracefully');
    server.close(() => {
        console.log('✅ HTTP server closed');
        process.exit(0);
    });
});

process.on('SIGINT', () => {
    console.log('🛑 Received SIGINT, shutting down gracefully');
    server.close(() => {
        console.log('✅ HTTP server closed');
        process.exit(0);
    });
});
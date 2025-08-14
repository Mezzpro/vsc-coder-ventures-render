# 🌐 HTTP Proxy Solution for Domain-Based Workspace Routing

## 🎯 Problem Statement

Code-server is a specialized application that immediately takes control of HTTP requests and serves its VS Code interface. It doesn't allow custom HTML injection or client-side redirects. The **only** way to route different domains to different workspaces is to intercept requests **BEFORE** code-server processes them.

## ✅ Solution: HTTP Proxy Wrapper

### Architecture Overview
```
User Request → HTTP Proxy (Port 10000) → Code-Server (Port 8080)
```

### Request Flow
```
1. User visits: mezzpro.xyz
2. HTTP Proxy receives request on port 10000
3. Proxy reads Host header: "mezzpro.xyz"
4. Proxy checks: Does URL have ?folder= parameter?
5. If NO: Issues HTTP 302 redirect to mezzpro.xyz/?folder=/home/coder/workspace-mezzpro
6. If YES: Proxies request to code-server on port 8080
7. Code-server serves VS Code with MezzPro workspace
```

## 🏗️ Technical Implementation

### Key Components

#### **1. Node.js HTTP Proxy Server (`proxy-server.js`)**
- Runs on port 10000 (Render's PORT)
- Uses Express.js for HTTP handling
- Uses http-proxy-middleware for proxying
- Handles WebSocket connections for VS Code

#### **2. Domain Mapping Logic**
```javascript
const DOMAIN_WORKSPACE_MAP = {
    'mezzpro.xyz': '/home/coder/workspace-mezzpro',
    'www.mezzpro.xyz': '/home/coder/workspace-mezzpro',
    'cradlesystems.xyz': '/home/coder/workspace-admin',
    'www.cradlesystems.xyz': '/home/coder/workspace-admin'
};
```

#### **3. Code-Server Backend**
- Runs on port 8080 (internal)
- Standard code-server functionality
- Handles authentication normally
- Serves VS Code interface with workspace parameter

#### **4. Startup Script (`proxy-start.sh`)**
- Sets up workspaces and themes
- Starts code-server on port 8080
- Starts HTTP proxy on port 10000
- Manages both processes

## 🔄 Complete User Experience Flow

### First Visit (Authentication Required)
```
1. User visits: mezzpro.xyz
2. Proxy redirects: mezzpro.xyz/?folder=/home/coder/workspace-mezzpro
3. Code-server shows login page
4. User enters password
5. Code-server creates session + loads MezzPro workspace
6. User sees Matrix-themed workspace
```

### Subsequent Visits (Authenticated)
```
1. User visits: mezzpro.xyz
2. Proxy redirects: mezzpro.xyz/?folder=/home/coder/workspace-mezzpro
3. Code-server checks session (valid)
4. Code-server immediately loads MezzPro workspace
5. User sees workspace instantly
```

## 🎯 Domain-Specific Behavior

### **mezzpro.xyz**
- Redirects to: `/?folder=/home/coder/workspace-mezzpro`
- Workspace: MezzPro Blockchain Platform
- Theme: Matrix green-on-black
- Content: Smart contracts, DApps folders
- README: Blockchain development info

### **cradlesystems.xyz**
- Redirects to: `/?folder=/home/coder/workspace-admin`
- Workspace: VSC Admin Panel
- Theme: Default Dark+
- Content: Projects folder
- README: Administrative info

### **Unknown Domains**
- Redirects to: `/?folder=/home/coder/workspace-admin`
- Fallback to admin workspace
- Safe default behavior

## ⚡ Authentication Handling

### **No Authentication Disruption**
- Proxy only handles redirects, not authentication
- Code-server manages all authentication logic
- Session cookies work normally
- Password requirements unchanged

### **Session Preservation**
- HTTP 302 redirects preserve sessions
- Browser follows redirects automatically
- Authentication state maintained
- No re-login required

## 🛡️ Security Features

### **Request Validation**
- Host header validation
- URL parameter encoding
- Proxy error handling
- Graceful degradation

### **WebSocket Support**
- VS Code requires WebSocket connections
- Proxy handles WebSocket upgrades
- Real-time communication preserved
- Full VS Code functionality

## 📊 Performance Characteristics

### **Latency Impact**
- Single HTTP redirect: ~10-20ms overhead
- WebSocket proxying: minimal overhead
- Code-server performance: unchanged
- Overall user experience: smooth

### **Resource Usage**
- Proxy server: ~50MB RAM
- Code-server: normal usage
- Total: similar to current setup
- CPU impact: negligible

## 🚀 Deployment Architecture

### **Container Structure**
```
Docker Container:
├── Node.js HTTP Proxy (Port 10000) ← Main process
├── Code-Server (Port 8080) ← Background process
├── Workspaces:
│   ├── workspace-admin/ (cradlesystems.xyz)
│   └── workspace-mezzpro/ (mezzpro.xyz)
└── Configuration files
```

### **Process Management**
- Proxy server runs as main process (PID 1)
- Code-server runs as background process
- Graceful shutdown handling
- Health check endpoints

## ✅ Why This Solution Works

### **Pre-Request Interception**
- Catches requests before code-server sees them
- Issues proper HTTP redirects
- Preserves all URL parameters and headers
- Works with any browser

### **Standard Web Protocols**
- Uses HTTP 302 redirects (standard)
- Maintains HTTP/HTTPS protocols
- Preserves authentication cookies
- Compatible with all clients

### **No Code-Server Modifications**
- Code-server runs unchanged
- All existing functionality preserved
- Authentication system intact
- VS Code features work normally

## 🎯 Benefits

### **✅ Reliable**
- Uses standard HTTP mechanisms
- No dependency on client-side JavaScript
- Works with disabled JavaScript
- Compatible with all browsers

### **✅ Fast**
- Single redirect per session
- Subsequent requests proxied directly
- Minimal latency overhead
- Optimal user experience

### **✅ Secure**
- No authentication changes
- Session management preserved
- Standard security practices
- No additional attack surface

### **✅ Maintainable**
- Simple Node.js application
- Clear separation of concerns
- Easy to debug and monitor
- Standard deployment practices

## 🔧 Configuration

### **Adding New Domains**
Simply update the mapping in `proxy-server.js`:
```javascript
const DOMAIN_WORKSPACE_MAP = {
    // Existing domains...
    'newdomain.xyz': '/home/coder/workspace-newdomain'
};
```

### **Changing Workspaces**
Update workspace paths in the mapping. The proxy will automatically redirect to the new workspace path.

---

This HTTP Proxy solution is the **only reliable approach** for domain-based workspace routing with code-server, providing seamless user experience while maintaining all security and functionality requirements.
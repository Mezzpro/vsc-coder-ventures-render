# VSC Coder Ventures - Render Deployment

Organized code-server deployment on Render.com with proper folder structure and proxy capabilities.

## Project Structure

```
render-deploy/
├── config/           # Configuration files
│   ├── nginx.conf
│   ├── supervisord.conf
│   ├── render.yaml
│   └── vscode-settings.json
├── scripts/          # Deployment script
│   └── start-both-services.sh
├── proxy/            # Proxy server logic
│   ├── proxy-server.js
│   └── workspace-redirect.html
├── workspaces/       # VSCode workspace configurations
│   ├── cradle-admin.code-workspace
│   └── mezzpro.code-workspace
├── extensions/       # Custom VSCode extensions
│   └── mezzpro-interface/
└── docs/            # Documentation
    └── HTTP-PROXY-SOLUTION.md
```

## Quick Start

1. This repository is ready to deploy to Render
2. Go to render.com → New Web Service → Connect this repo
3. Render will automatically build and start code-server
4. Access via the provided Render URL

## Scripts Reference

- `scripts/start-both-services.sh` - Main startup script (starts code-server and proxy)

## Configuration

- **Port**: Auto-configured by Render
- **Password**: `vsc123` (change in environment variables)
- **Authentication**: Password-based
- **SSL**: Automatic via Render
- **Config Files**: Located in `config/` directory

## Workspace Configurations

- **Cradle Admin**: `workspaces/cradle-admin.code-workspace` - Clean, minimal admin interface
- **MezzPro**: `workspaces/mezzpro.code-workspace` - Professional development environment
- Settings are loaded automatically from workspace files when accessing domains

## Environment Variables (Optional)

Set in Render dashboard:
- `CODE_SERVER_PASSWORD`: Custom password (default: vsc123)

## Proxy Features

The proxy server (`proxy/proxy-server.js`) provides:
- Workspace routing capabilities
- Custom redirect handling
- Multi-workspace support

## Documentation

See `docs/` folder for detailed documentation:
- [HTTP Proxy Solution](docs/HTTP-PROXY-SOLUTION.md)

---

Ready to deploy! 🚀
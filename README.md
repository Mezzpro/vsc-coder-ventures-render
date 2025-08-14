# VSC Coder Ventures - Render Deployment

Basic code-server deployment on Render.com for testing.

## Quick Start

1. This repository is ready to deploy to Render
2. Go to render.com → New Web Service → Connect this repo
3. Render will automatically build and start code-server
4. Access via the provided Render URL

## Default Configuration

- **Port**: Auto-configured by Render
- **Password**: `vsc123` (change in environment variables)
- **Authentication**: Password-based
- **SSL**: Automatic via Render

## Environment Variables (Optional)

Set in Render dashboard:
- `CODE_SERVER_PASSWORD`: Custom password (default: vsc123)

---

Ready to deploy! 🚀
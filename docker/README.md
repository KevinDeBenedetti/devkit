# Docker Library

A collection of production-ready Dockerfile templates for various frameworks and technologies.

## 📋 Overview

This repository contains optimized Docker configurations for different project types, designed with best practices for development and production environments. Each template includes multi-stage builds, proper caching strategies, and security considerations.

## 🏗️ Available Templates

### Frontend Frameworks

- **[Vue.js](./vue/)** - Complete setup for Vue.js applications with development and production stages

### Coming Soon

- **Nuxt.js** - Full-stack Vue.js framework

### Backend Frameworks

- **FastAPI** - Modern Python web framework

## 🚀 Quick Start

1. **Choose a template** from the available directories
2. **Copy the files** to your project:
   ```bash
   cp docker-library/vue/Dockerfile your-project/
   cp docker-library/vue/.dockerignore your-project/
   ```
3. **Customize** the configuration according to your needs
4. **Build and run** your container

## 📁 Template Structure

Each template directory contains:

```
framework-name/
├── Dockerfile          # Multi-stage Docker configuration
├── .dockerignore       # Files to exclude from Docker context
└── README.md          # Framework-specific documentation
```

## 🔧 Build Arguments

Most templates support common build arguments:

- `NODE_VERSION` - Node.js version (for JavaScript frameworks)
- `PYTHON_VERSION` - Python version (for Python frameworks)
- `APP_PORT` - Application port
- `PNPM_VERSION` - PNPM version (when applicable)

Example:
```bash
docker build \
  --build-arg NODE_VERSION=20 \
  --build-arg PNPM_VERSION=8 \
  --build-arg APP_PORT=3000 \
  -t my-app .
```

## 🎯 Build Targets

Templates include multiple build targets:

- **`dev`** - Development environment with hot reload
- **`build`** - Build stage for compiling assets
- **`prod`** - Production-ready lightweight image

Build specific target:
```bash
docker build --target dev -t my-app:dev .
docker build --target prod -t my-app:prod .
```

## 🐳 Docker Compose

Each template can be used with Docker Compose. Example configuration:

```yaml
version: '3.8'
services:
  app:
    build:
      context: .
      target: dev
      args:
        NODE_VERSION: 20
        APP_PORT: 3000
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
```

## 🔒 Security Features

All templates include:

- Non-root user execution
- Minimal base images
- Multi-stage builds to reduce attack surface
- Health checks
- Proper file permissions

## 🤝 Contributing

Contributions are welcome! To add a new template:

1. Create a new directory with the framework name
2. Include `Dockerfile`, `.dockerignore`, and `README.md`
3. Follow the existing patterns for consistency
4. Test with both development and production builds
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏷️ Tags

`docker` `dockerfile` `templates` `vue` `nuxt` `react` `nextjs` `fastapi` `python` `nodejs` `frontend` `backend` `devops` `containers`


# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copie les fichiers de dépendances
COPY package*.json ./

# Installe les dépendances
RUN npm ci

# Copie le code source
COPY . .

# Build l'application Nuxt
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Copie les fichiers nécessaires depuis le builder
COPY --from=builder /app/.output /app/.output
COPY --from=builder /app/package*.json ./

# Installe uniquement les dépendances de production
RUN npm ci --only=production

# Expose le port
EXPOSE 3000

# Variables d'environnement
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

# Lance l'application
CMD ["node", ".output/server/index.mjs"]
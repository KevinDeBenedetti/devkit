#!/bin/sh
set -e

REPO="KevinDeBenedetti/devkit"
VERSION="${1:-latest}"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$OS" in
    linux*)
        if [ "$ARCH" = "x86_64" ]; then
            BINARY="devkit-x86_64-linux-gnu.tar.gz"
        elif [ "$ARCH" = "aarch64" ]; then
            BINARY="devkit-aarch64-linux-gnu.tar.gz"
        fi
        ;;
    darwin*)
        if [ "$ARCH" = "x86_64" ]; then
            BINARY="devkit-x86_64-darwin.tar.gz"
        elif [ "$ARCH" = "arm64" ]; then
            BINARY="devkit-aarch64-darwin.tar.gz"
        fi
        ;;
esac

# Download and install
URL="https://github.com/$REPO/releases/latest/download/$BINARY"
curl -fsSL "$URL" | tar xz -C /usr/local/bin

echo "✅ devkit installed successfully!"
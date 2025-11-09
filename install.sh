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

# Check if BINARY is set
if [ -z "$BINARY" ]; then
    echo "❌ Unsupported OS/architecture combination: $OS/$ARCH"
    exit 1
fi
# Download and install
URL="https://github.com/$REPO/releases/latest/download/$BINARY"

# Check for write permissions to /usr/local/bin
if [ ! -w /usr/local/bin ]; then
    echo "❌ Installation failed. You may need to run this script with sudo." >&2
    exit 1
fi
curl -fsSL "$URL" | tar xz -C /usr/local/bin

echo "✅ devkit installed successfully!"
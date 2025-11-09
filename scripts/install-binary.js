#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const https = require('https');
const { execSync } = require('child_process');

const PACKAGE_NAME = '@kevindebenedetti/devkit';
const VERSION = require('../package.json').version;

function getPlatform() {
  const platform = process.platform;
  const arch = process.arch;

  const platformMap = {
    'darwin-x64': 'darwin-x64',
    'darwin-arm64': 'darwin-arm64',
    'linux-x64': 'linux-x64',
    'linux-arm64': 'linux-arm64',
    'win32-x64': 'windows-x64',
  };

  const key = `${platform}-${arch}`;
  if (!platformMap[key]) {
    throw new Error(`Unsupported platform: ${key}`);
  }

  return platformMap[key];
}

function getBinaryName() {
  return process.platform === 'win32' ? 'devkit.exe' : 'devkit';
}

async function downloadBinary(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);
    https.get(url, (response) => {
      if (response.statusCode === 302 || response.statusCode === 301) {
        // Follow redirects
        return downloadBinary(response.headers.location, dest)
          .then(resolve)
          .catch(reject);
      }

      if (response.statusCode !== 200) {
        reject(new Error(`HTTP error: ${response.statusCode}`));
        return;
      }

      response.pipe(file);
      file.on('finish', () => {
        file.close();
        resolve();
      });
    }).on('error', (err) => {
      fs.unlink(dest, () => { });
      reject(err);
    });
  });
}

async function install() {
  try {
    console.log('📦 Installing devkit...');

    const platform = getPlatform();
    const binaryName = getBinaryName();
    const binDir = path.join(__dirname, '..', 'bin');
    const binaryPath = path.join(binDir, binaryName);

    // Create the bin folder if it doesn't exist
    if (!fs.existsSync(binDir)) {
      fs.mkdirSync(binDir, { recursive: true });
    }

    // Binary URL on GitHub Releases
    const url = `https://github.com/KevinDeBenedetti/devkit/releases/download/v${VERSION}/devkit-${platform}${process.platform === 'win32' ? '.exe' : ''}`;

    console.log(`📥 Downloading from: ${url}`);
    await downloadBinary(url, binaryPath);

    // Make the binary executable (Unix)
    if (process.platform !== 'win32') {
      fs.chmodSync(binaryPath, '755');
    }

    console.log('✅ devkit installed successfully!');
    console.log(`\n🚀 Run 'devkit init' to get started\n`);
  } catch (error) {
    console.error('❌ Error during installation:', error.message);
    console.error('\n💡 Try installing manually from:');
    console.error(`   https://github.com/KevinDeBenedetti/devkit/releases\n`);
    process.exit(1);
  }
}

install();
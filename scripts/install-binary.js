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
    throw new Error(`Plateforme non supportée: ${key}`);
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
        // Suit les redirections
        return downloadBinary(response.headers.location, dest)
          .then(resolve)
          .catch(reject);
      }
      
      if (response.statusCode !== 200) {
        reject(new Error(`Erreur HTTP: ${response.statusCode}`));
        return;
      }

      response.pipe(file);
      file.on('finish', () => {
        file.close();
        resolve();
      });
    }).on('error', (err) => {
      fs.unlink(dest, () => {});
      reject(err);
    });
  });
}

async function install() {
  try {
    console.log('📦 Installation de devkit...');
    
    const platform = getPlatform();
    const binaryName = getBinaryName();
    const binDir = path.join(__dirname, '..', 'bin');
    const binaryPath = path.join(binDir, binaryName);

    // Crée le dossier bin s'il n'existe pas
    if (!fs.existsSync(binDir)) {
      fs.mkdirSync(binDir, { recursive: true });
    }

    // URL du binaire sur GitHub Releases
    const url = `https://github.com/KevinDeBenedetti/devkit/releases/download/v${VERSION}/devkit-${platform}${process.platform === 'win32' ? '.exe' : ''}`;

    console.log(`📥 Téléchargement depuis: ${url}`);
    await downloadBinary(url, binaryPath);

    // Rend le binaire exécutable (Unix)
    if (process.platform !== 'win32') {
      fs.chmodSync(binaryPath, '755');
    }

    console.log('✅ devkit installé avec succès !');
    console.log(`\n🚀 Lancez 'devkit init' pour commencer\n`);
  } catch (error) {
    console.error('❌ Erreur lors de l\'installation:', error.message);
    console.error('\n💡 Essayez d\'installer manuellement depuis:');
    console.error(`   https://github.com/KevinDeBenedetti/devkit/releases\n`);
    process.exit(1);
  }
}

install();
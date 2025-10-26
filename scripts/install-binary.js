const fs = require('fs');
const path = require('path');
const https = require('https');
const { execSync } = require('child_process');

const REPO = 'KevinDeBenedetti/devkit';
const VERSION = require('../package.json').version;

function getPlatformInfo() {
  const platform = process.platform;
  const arch = process.arch;
  
  const platformMap = {
    'darwin': {
      'x64': 'x86_64-apple-darwin',
      'arm64': 'aarch64-apple-darwin'
    },
    'linux': {
      'x64': 'x86_64-unknown-linux-gnu',
      'arm64': 'aarch64-unknown-linux-gnu'
    },
    'win32': {
      'x64': 'x86_64-pc-windows-gnu'
    }
  };
  
  const target = platformMap[platform]?.[arch];
  
  if (!target) {
    throw new Error(`Unsupported platform: ${platform}-${arch}`);
  }
  
  return {
    platform,
    arch,
    target,
    binaryName: platform === 'win32' ? 'installer.exe' : 'installer'
  };
}

async function downloadBinary(url, destination) {
  return new Promise((resolve, reject) => {
    console.log(`📥 Downloading binary from ${url}...`);
    
    const file = fs.createWriteStream(destination);
    
    const request = https.get(url, (response) => {
      // Handle redirects
      if (response.statusCode === 301 || response.statusCode === 302) {
        return downloadBinary(response.headers.location, destination)
          .then(resolve)
          .catch(reject);
      }
      
      if (response.statusCode !== 200) {
        reject(new Error(`Download failed: HTTP ${response.statusCode}`));
        return;
      }
      
      const totalBytes = parseInt(response.headers['content-length'], 10);
      let downloadedBytes = 0;
      
      response.on('data', (chunk) => {
        downloadedBytes += chunk.length;
        if (totalBytes) {
          const percent = ((downloadedBytes / totalBytes) * 100).toFixed(1);
          process.stdout.write(`\r📦 Progress: ${percent}%`);
        }
      });
      
      response.pipe(file);
      
      file.on('finish', () => {
        file.close();
        console.log('\n✓ Download complete');
        resolve();
      });
    });
    
    request.on('error', (err) => {
      fs.unlink(destination, () => {});
      reject(err);
    });
  });
}

function buildFromSource(binaryPath, binaryName) {
  console.log('⚠️  Building from source...');
  
  try {
    execSync('cargo build --release', {
      stdio: 'inherit',
      cwd: path.join(__dirname, '..')
    });
    
    const sourceBinary = path.join(
      __dirname,
      '..',
      'target',
      'release',
      binaryName
    );
    
    if (!fs.existsSync(sourceBinary)) {
      throw new Error('Build completed but binary not found');
    }
    
    fs.copyFileSync(sourceBinary, binaryPath);
    console.log('✅ Built from source successfully!');
    return true;
  } catch (error) {
    console.error('❌ Build failed:', error.message);
    return false;
  }
}

async function installBinary() {
  try {
    console.log('🚀 Installing project-installer binary...\n');
    
    const platformInfo = getPlatformInfo();
    const binDir = path.join(__dirname, '..', 'bin');
    const binaryPath = path.join(binDir, platformInfo.binaryName);
    
    // Check if already installed
    if (fs.existsSync(binaryPath)) {
      console.log('✅ Binary already installed');
      return;
    }
    
    // Create bin directory
    if (!fs.existsSync(binDir)) {
      fs.mkdirSync(binDir, { recursive: true });
    }
    
    // Try to download from GitHub Releases
    const downloadUrl = `https://github.com/${REPO}/releases/download/v${VERSION}/installer-${platformInfo.target}`;
    
    try {
      await downloadBinary(downloadUrl, binaryPath);
      
      // Make executable on Unix
      if (platformInfo.platform !== 'win32') {
        fs.chmodSync(binaryPath, '755');
      }
      
      console.log('✅ Installation successful!\n');
      console.log('Run: npx installer --help');
      
    } catch (downloadError) {
      console.log('⚠️  Download failed:', downloadError.message);
      console.log('📦 Attempting to build from source...\n');
      
      const buildSuccess = buildFromSource(binaryPath, platformInfo.binaryName);
      
      if (!buildSuccess) {
        throw new Error(
          'Installation failed. Please ensure Rust is installed:\n' +
          'https://rustup.rs/'
        );
      }
      
      // Make executable on Unix
      if (platformInfo.platform !== 'win32') {
        fs.chmodSync(binaryPath, '755');
      }
    }
    
  } catch (error) {
    console.error('\n❌ Installation failed:', error.message);
    console.error('\nTroubleshooting:');
    console.error('1. Ensure you have internet connection');
    console.error('2. Install Rust: https://rustup.rs/');
    console.error('3. Run: cargo build --release');
    process.exit(1);
  }
}

// Only run if not in npm pack/publish
if (!process.env.npm_package_json || fs.existsSync(path.join(__dirname, '..', 'Cargo.toml'))) {
  installBinary().catch((error) => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
}
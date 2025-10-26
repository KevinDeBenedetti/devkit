const { spawnSync } = require('child_process');
const path = require('path');
const fs = require('fs');

function getBinaryPath() {
  const platform = process.platform;
  const binaryName = platform === 'win32' ? 'installer.exe' : 'installer';
  const binaryPath = path.join(__dirname, 'bin', binaryName);
  
  if (!fs.existsSync(binaryPath)) {
    console.error('❌ Binary not found.');
    console.error('Please reinstall: npm install -g @votre-scope/project-installer');
    process.exit(1);
  }
  
  return binaryPath;
}

const binaryPath = getBinaryPath();
const result = spawnSync(binaryPath, process.argv.slice(2), {
  stdio: 'inherit'
});

process.exit(result.status || 0);
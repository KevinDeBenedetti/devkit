#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');

const binaryName = process.platform === 'win32' ? 'devkit.exe' : 'devkit';
const binaryPath = path.join(__dirname, 'bin', binaryName);

// Lance le binaire Rust avec tous les arguments
const child = spawn(binaryPath, process.argv.slice(2), {
  stdio: 'inherit',
  env: process.env,
});

child.on('error', (error) => {
  console.error('Erreur lors du lancement de devkit:', error.message);
  process.exit(1);
});

child.on('exit', (code) => {
  process.exit(code || 0);
});
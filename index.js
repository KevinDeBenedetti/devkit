const { execSync } = require('child_process');
const path = require('path');

const binaryName = process.platform === 'win32' ? 'devkit.exe' : 'devkit';
const binaryPath = path.join(__dirname, 'bin', binaryName);

/**
 * Execute a devkit command
 */
function executeCommand(args) {
  try {
    const result = execSync(`"${binaryPath}" ${args.join(' ')}`, {
      encoding: 'utf-8',
      stdio: ['pipe', 'pipe', 'pipe'],
    });
    return result;
  } catch (error) {
    throw new Error(`devkit error: ${error.message}`);
  }
}

/**
 * List all available stacks
 */
async function listStacks() {
  const output = executeCommand(['list']);
  return output
    .split('\n')
    .filter(line => line.startsWith('  •'))
    .map(line => line.replace('  •', '').trim());
}

/**
 * Configure a project with the specified stack
 */
async function configureStack(options) {
  if (!options.stack) {
    throw new Error('The "stack" parameter is required');
  }

  const args = ['config', options.stack];

  if (options.projectPath) {
    process.chdir(options.projectPath);
  }

  executeCommand(args);
}

/**
 * Get a stack configuration (placeholder for future implementation)
 */
async function getStackConfig(stack) {
  throw new Error('getStackConfig is not implemented yet');
}

module.exports = {
  listStacks,
  configureStack,
  getStackConfig,
};
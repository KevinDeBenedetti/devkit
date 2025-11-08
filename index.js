const { execSync } = require('child_process');
const path = require('path');

const binaryName = process.platform === 'win32' ? 'devkit.exe' : 'devkit';
const binaryPath = path.join(__dirname, 'bin', binaryName);

/**
 * Exécute une commande devkit
 */
function executeCommand(args) {
  try {
    const result = execSync(`"${binaryPath}" ${args.join(' ')}`, {
      encoding: 'utf-8',
      stdio: ['pipe', 'pipe', 'pipe'],
    });
    return result;
  } catch (error) {
    throw new Error(`Erreur devkit: ${error.message}`);
  }
}

/**
 * Liste toutes les stacks disponibles
 */
async function listStacks() {
  const output = executeCommand(['list']);
  return output
    .split('\n')
    .filter(line => line.startsWith('  •'))
    .map(line => line.replace('  •', '').trim());
}

/**
 * Configure un projet avec la stack spécifiée
 */
async function configureStack(options) {
  if (!options.stack) {
    throw new Error('Le paramètre "stack" est requis');
  }

  const args = ['config', options.stack];
  
  if (options.projectPath) {
    process.chdir(options.projectPath);
  }

  executeCommand(args);
}

/**
 * Récupère la configuration d'une stack (placeholder pour future implémentation)
 */
async function getStackConfig(stack) {
  throw new Error('getStackConfig n\'est pas encore implémenté');
}

module.exports = {
  listStacks,
  configureStack,
  getStackConfig,
};
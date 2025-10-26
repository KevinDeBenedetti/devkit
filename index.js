const { spawnSync, spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

class ProjectInstaller {
  constructor(options = {}) {
    this.silent = options.silent || false;
    this.cwd = options.cwd || process.cwd();
    this.binaryPath = this._getBinaryPath();
  }

  _getBinaryPath() {
    const platform = process.platform;
    const binaryName = platform === 'win32' ? 'installer.exe' : 'installer';
    const binaryPath = path.join(__dirname, 'bin', binaryName);
    
    if (!fs.existsSync(binaryPath)) {
      throw new Error(
        'Binary not found. Please reinstall the package:\n' +
        'npm install @my-scope/devkit'
      );
    }
    
    return binaryPath;
  }

  _exec(args, options = {}) {
    const result = spawnSync(this.binaryPath, args, {
      stdio: this.silent ? 'pipe' : 'inherit',
      cwd: options.cwd || this.cwd,
      encoding: 'utf-8'
    });

    if (result.error) {
      throw new Error(`Execution failed: ${result.error.message}`);
    }

    return {
      success: result.status === 0,
      code: result.status,
      stdout: result.stdout || '',
      stderr: result.stderr || ''
    };
  }

  _execAsync(args, options = {}) {
    return new Promise((resolve, reject) => {
      const child = spawn(this.binaryPath, args, {
        cwd: options.cwd || this.cwd
      });

      let stdout = '';
      let stderr = '';

      if (child.stdout) {
        child.stdout.on('data', (data) => {
          const text = data.toString();
          stdout += text;
          if (options.onStdout) options.onStdout(text);
        });
      }

      if (child.stderr) {
        child.stderr.on('data', (data) => {
          const text = data.toString();
          stderr += text;
          if (options.onStderr) options.onStderr(text);
        });
      }

      child.on('error', reject);
      child.on('close', (code) => {
        resolve({
          success: code === 0,
          code,
          stdout,
          stderr
        });
      });
    });
  }

  // Public API

  /**
   * Initialize a new project from a template
   */
  init(template, output = '.', options = {}) {
    return this._exec(['init', template, output], options);
  }

  /**
   * Setup Docker configuration
   */
  setupDocker(options = {}) {
    const args = ['docker'];
    if (options.compose) {
      args.push('--compose');
    }
    return this._exec(args, options);
  }

  /**
   * Setup Makefile
   */
  setupMakefile(options = {}) {
    return this._exec(['makefile'], options);
  }

  /**
   * List available templates
   */
  listTemplates(options = {}) {
    // CORRECTION : Exécuter avec stdio 'pipe' pour capturer la sortie
    const result = spawnSync(this.binaryPath, ['list'], {
      stdio: 'pipe',
      cwd: options.cwd || this.cwd,
      encoding: 'utf-8'
    });
    
    if (result.error) {
      throw new Error(`Failed to list templates: ${result.error.message}`);
    }

    if (result.status !== 0) {
      return { 
        success: false, 
        templates: [],
        error: result.stderr || 'Command failed'
      };
    }

    // Vérifier que stdout existe et n'est pas null
    if (!result.stdout) {
      return { 
        success: false, 
        templates: [],
        error: 'No output from command'
      };
    }

    // Parse output to extract template names
    const templates = [];
    const lines = result.stdout.split('\n');
    
    for (const line of lines) {
      // Format attendu: "  rust-cli - Rust CLI application with clap"
      const match = line.match(/^\s+(\S+)\s+-\s+(.+)$/);
      if (match) {
        templates.push({
          name: match[1],
          description: match[2].trim()
        });
      }
    }

    return { success: true, templates };
  }

  /**
   * Get version
   */
  version() {
    const result = spawnSync(this.binaryPath, ['version'], {
      stdio: 'pipe',
      encoding: 'utf-8'
    });
    
    if (result.error || result.status !== 0) {
      return 'unknown';
    }
    
    return (result.stdout || '').trim();
  }

  /**
   * Run custom command
   */
  run(args, options = {}) {
    return this._exec(args, options);
  }

  /**
   * Run custom command asynchronously
   */
  async runAsync(args, options = {}) {
    return this._execAsync(args, options);
  }
}

// Exports
module.exports = ProjectInstaller;
module.exports.ProjectInstaller = ProjectInstaller;

// Helper functions
module.exports.init = function(template, output, options) {
  const installer = new ProjectInstaller(options);
  return installer.init(template, output, options);
};

module.exports.setupDocker = function(options) {
  const installer = new ProjectInstaller(options);
  return installer.setupDocker(options);
};

module.exports.setupMakefile = function(options) {
  const installer = new ProjectInstaller(options);
  return installer.setupMakefile(options);
};

module.exports.listTemplates = function() {
  const installer = new ProjectInstaller({ silent: true });
  return installer.listTemplates();
};
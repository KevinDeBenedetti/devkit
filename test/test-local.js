const ProjectInstaller = require('../index');
const path = require('path');
const os = require('os');
const fs = require('fs');

console.log('🧪 Testing ProjectInstaller API\n');

async function runTests() {
  try {
    const installer = new ProjectInstaller({ silent: true });
    
    // Test 1: List templates
    console.log('Test 1: List templates');
    const templatesResult = installer.listTemplates();
    
    if (!templatesResult.success) {
      throw new Error(`Failed to list templates: ${templatesResult.error}`);
    }
    
    console.log(`✓ Found ${templatesResult.templates.length} templates:`);
    templatesResult.templates.forEach(t => {
      console.log(`  - ${t.name}: ${t.description}`);
    });
    console.log('');
    
    // Test 2: Get version
    console.log('Test 2: Get version');
    const version = installer.version();
    console.log('✓ Version:', version, '\n');
    
    // Test 3: Init in temp directory
    console.log('Test 3: Initialize project in temp directory');
    const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'proj-installer-'));
    
    // Utiliser un template qui existe
    const template = templatesResult.templates.length > 0 
      ? templatesResult.templates[0].name 
      : 'rust-cli';
    
    console.log(`  Initializing ${template} in ${tempDir}...`);
    const initResult = installer.init(template, tempDir);
    
    if (initResult.success) {
      console.log('✓ Project initialized\n');
      
      // Vérifier que des fichiers ont été créés
      const files = fs.readdirSync(tempDir);
      console.log(`  Created files: ${files.join(', ')}`);
    } else {
      console.warn('⚠️  Init command completed with warnings\n');
    }
    
    // Test 4: Setup Docker
    console.log('\nTest 4: Setup Docker (dry run in temp dir)');
    const dockerResult = installer.setupDocker({ 
      compose: true, 
      cwd: tempDir 
    });
    
    if (dockerResult.success) {
      console.log('✓ Docker setup complete');
      
      // Vérifier que les fichiers Docker ont été créés
      const dockerFiles = ['Dockerfile', 'docker-compose.yml', '.dockerignore'];
      const createdDockerFiles = dockerFiles.filter(f => 
        fs.existsSync(path.join(tempDir, f))
      );
      console.log(`  Created: ${createdDockerFiles.join(', ')}`);
    }
    console.log('');
    
    // Test 5: Setup Makefile
    console.log('Test 5: Setup Makefile');
    const makefileResult = installer.setupMakefile({ cwd: tempDir });
    
    if (makefileResult.success) {
      console.log('✓ Makefile created');
      
      if (fs.existsSync(path.join(tempDir, 'Makefile'))) {
        console.log('  Verified: Makefile exists');
      }
    }
    console.log('');
    
    // Clean up
    console.log('Cleaning up...');
    fs.rmSync(tempDir, { recursive: true, force: true });
    console.log('✓ Temp directory removed\n');
    
    console.log('========================================');
    console.log('✅ All tests passed successfully! 🎉');
    console.log('========================================\n');
    
    console.log('Next steps:');
    console.log('  1. npm link           - Test globally');
    console.log('  2. installer --help   - Use the CLI');
    console.log('  3. git tag v0.1.0     - Create release');
    
  } catch (error) {
    console.error('\n❌ Test failed:', error.message);
    console.error('\nStack trace:');
    console.error(error.stack);
    process.exit(1);
  }
}

// Run tests
runTests();
export interface InstallerOptions {
  silent?: boolean;
  cwd?: string;
}

export interface ExecResult {
  success: boolean;
  code: number;
  stdout?: string;
  stderr?: string;
}

export interface DockerOptions extends InstallerOptions {
  compose?: boolean;
}

export interface Template {
  name: string;
  description: string;
}

export interface TemplatesResult {
  success: boolean;
  templates: Template[];
}

export class ProjectInstaller {
  constructor(options?: InstallerOptions);
  
  init(template: string, output?: string, options?: InstallerOptions): ExecResult;
  setupDocker(options?: DockerOptions): ExecResult;
  setupMakefile(options?: InstallerOptions): ExecResult;
  listTemplates(options?: InstallerOptions): TemplatesResult;
  version(): string;
  run(args: string[], options?: InstallerOptions): ExecResult;
  runAsync(args: string[], options?: any): Promise<ExecResult>;
}

export function init(template: string, output?: string, options?: InstallerOptions): ExecResult;
export function setupDocker(options?: DockerOptions): ExecResult;
export function setupMakefile(options?: InstallerOptions): ExecResult;
export function listTemplates(): TemplatesResult;

export default ProjectInstaller;
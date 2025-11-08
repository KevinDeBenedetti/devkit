export interface StackConfig {
  name: string;
  description: string;
  files: FileTemplate[];
  dependencies: string[];
}

export interface FileTemplate {
  path: string;
  content: string;
}

export interface DevkitOptions {
  stack: string;
  projectPath?: string;
}

/**
 * Liste toutes les stacks disponibles
 */
export function listStacks(): Promise<string[]>;

/**
 * Configure un projet avec la stack spécifiée
 */
export function configureStack(options: DevkitOptions): Promise<void>;

/**
 * Récupère la configuration d'une stack
 */
export function getStackConfig(stack: string): Promise<StackConfig>;
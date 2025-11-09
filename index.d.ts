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
 * List all available stacks
 */
export function listStacks(): Promise<string[]>;

/**
 * Configure a project with the specified stack
 */
export function configureStack(options: DevkitOptions): Promise<void>;

/**
 * Retrieve the configuration of a stack
 */
export function getStackConfig(stack: string): Promise<StackConfig>;
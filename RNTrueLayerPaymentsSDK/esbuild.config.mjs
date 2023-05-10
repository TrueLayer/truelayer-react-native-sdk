import { build } from 'esbuild';
import { clean } from 'esbuild-plugin-clean';
import { exec } from 'child_process'

async function generateDeclarations() {
  return new Promise((resolve, reject) => {
    exec('tsc --emitDeclarationOnly', (error) => {
      if (error) {
        console.error('Error generating declarations:', error);
        reject(error);
      } else {
        console.log('Declarations generated successfully');
        resolve(true);
      }
    });
  });
}

try {
  await build({
    entryPoints: ['js/index.ts'],
    bundle: true,
    platform: 'neutral',
    target: 'es2017',
    loader: {
      '.ts': 'ts',
    },
    external: ['react', 'react-native'],
    minify: true,
    sourcemap: 'inline',
    outfile: 'lib/index.js',
    format: 'esm',
    tsconfig: 'tsconfig.json',
    plugins: [
      clean({
        patterns: ['lib']
      }),
    ],
  });
  await generateDeclarations()
} catch (error) {
  console.error('Build failed:', error);
  process.exit(1);
}

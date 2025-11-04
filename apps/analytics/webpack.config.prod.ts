import { composePlugins, withNx } from '@nx/webpack';
import { withReact } from '@nx/react';
import { withModuleFederation } from '@nx/module-federation/webpack.js';

import baseConfig from './module-federation.config';

const config = {
  ...baseConfig,
};

// Nx plugins for webpack to build config object from Nx options and context.
/**
 * DTS Plugin is disabled in Nx Workspaces as Nx already provides Typing support Module Federation
 * The DTS Plugin can be enabled by setting dts: true
 * Learn more about the DTS Plugin here: https://module-federation.io/configure/dts.html
 */
export default composePlugins(
  withNx({
    target: 'web',
  }),
  withReact(),
  withModuleFederation(config, { dts: false }),
  (config) => {
    // Add Node.js externals to prevent bundling Node.js modules
    config.externals = config.externals || [];
    if (Array.isArray(config.externals)) {
      config.externals.push({
        'node:stream': 'commonjs node:stream',
        'node:url': 'commonjs node:url',
        'node:util': 'commonjs node:util',
        'node:vm': 'commonjs node:vm',
        'node:wasi': 'commonjs node:wasi',
        'node:worker_threads': 'commonjs node:worker_threads',
        'node:zlib': 'commonjs node:zlib',
      });
    }

    // Disable Terser minification that's causing issues
    if (config.optimization?.minimizer) {
      config.optimization.minimizer = config.optimization.minimizer.filter(
        (minimizer: any) => minimizer.constructor.name !== 'TerserPlugin'
      );
    }

    return config;
  }
);

import { composePlugins, withNx } from '@nx/webpack';
import { withReact } from '@nx/react';
import { withModuleFederation } from '@nx/module-federation/webpack.js';
import { ModuleFederationConfig } from '@nx/module-federation';
import baseConfig from './module-federation.config';

const prodConfig: ModuleFederationConfig = {
  ...baseConfig,
  /*
   * Remote overrides for production.
   * Each entry is a pair of a unique name and the URL where it is deployed.
   */
  remotes: [
    ['dashboard', 'https://d1osxfiyfuu861.cloudfront.net/dashboard/'],
    ['analytics', 'https://d1osxfiyfuu861.cloudfront.net/analytics/'],
    ['products', 'https://d1osxfiyfuu861.cloudfront.net/products/'],
    ['orders', 'https://d1osxfiyfuu861.cloudfront.net/orders/'],
  ],
};

// Nx plugins for webpack to build config object from Nx options and context.
/**
 * DTS Plugin is disabled in Nx Workspaces as Nx already provides Typing support for Module Federation
 * The DTS Plugin can be enabled by setting dts: true
 * Learn more about the DTS Plugin here: https://module-federation.io/configure/dts.html
 */
export default composePlugins(
  withNx({
    target: 'web',
  }),
  withReact(),
  withModuleFederation(prodConfig, { dts: false }),
  (config, context) => {
    // Add environment variables using webpack from context
    const { DefinePlugin } = require('webpack');
    
    config.plugins = config.plugins || [];
    config.plugins.push(
      new DefinePlugin({
        'process.env.REACT_APP_API_USERS_URL': JSON.stringify(
          process.env.REACT_APP_API_USERS_URL ||
            'http://micro-frontend-api-alb-dev-931650639.us-east-1.elb.amazonaws.com/api/users'
        ),
        'process.env.REACT_APP_API_ORDERS_URL': JSON.stringify(
          process.env.REACT_APP_API_ORDERS_URL ||
            'http://micro-frontend-api-alb-dev-931650639.us-east-1.elb.amazonaws.com/api/orders'
        ),
        'process.env.REACT_APP_API_PRODUCTS_URL': JSON.stringify(
          process.env.REACT_APP_API_PRODUCTS_URL ||
            'http://micro-frontend-api-alb-dev-931650639.us-east-1.elb.amazonaws.com/api/products'
        ),
      })
    );

    // Add Node.js externals to prevent bundling Node.js modules
    config.externals = config.externals || [];
    config.externals.push({
      'node:stream': 'commonjs node:stream',
      'node:url': 'commonjs node:url',
      'node:util': 'commonjs node:util',
      'node:vm': 'commonjs node:vm',
      'node:wasi': 'commonjs node:wasi',
      'node:worker_threads': 'commonjs node:worker_threads',
      'node:zlib': 'commonjs node:zlib',
    });

    // Disable Terser minification that's causing issues
    if (config.optimization && config.optimization.minimizer) {
      config.optimization.minimizer = config.optimization.minimizer.filter(
        (minimizer) => minimizer.constructor.name !== 'TerserPlugin'
      );
    }

    return config;
  }
);

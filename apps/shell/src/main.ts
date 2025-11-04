import { init } from '@module-federation/enhanced/runtime';

const isProduction = process.env.NODE_ENV === 'production';

const remotes = isProduction
  ? [
      {
        name: 'dashboard',
        entry: 'https://d1osxfiyfuu861.cloudfront.net/dashboard/remoteEntry.js',
      },
      {
        name: 'analytics',
        entry: 'https://d1osxfiyfuu861.cloudfront.net/analytics/remoteEntry.js',
      },
      {
        name: 'products',
        entry: 'https://d1osxfiyfuu861.cloudfront.net/products/remoteEntry.js',
      },
      {
        name: 'orders',
        entry: 'https://d1osxfiyfuu861.cloudfront.net/orders/remoteEntry.js',
      },
    ]
  : [
      {
        name: 'dashboard',
        entry: 'http://localhost:4301/remoteEntry.js',
      },
      {
        name: 'analytics',
        entry: 'http://localhost:4302/remoteEntry.js',
      },
      {
        name: 'products',
        entry: 'http://localhost:4303/remoteEntry.js',
      },
      {
        name: 'orders',
        entry: 'http://localhost:4304/remoteEntry.js',
      },
    ];

try {
  init({
    name: 'shell',
    remotes,
  });
  import('./bootstrap');
} catch (err) {
  console.error('Error loading remote entries', err);
  import('./bootstrap');
}

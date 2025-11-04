import { init, loadRemote } from '@module-federation/enhanced/runtime';

fetch('/assets/module-federation.manifest.json')
  .then((res) => res.json())
  .then((definitions) => init({ name: 'shell', remotes: definitions }))
  .then(() => import('./bootstrap'))
  .catch((err) => {
    console.error('Error loading remote entries', err);
    import('./bootstrap');
  });
# Force frontend rebuild

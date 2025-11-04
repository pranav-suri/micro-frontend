// Module Federation is configured via webpack config
// Just bootstrap the application
import('./bootstrap').catch((err) => {
  console.error('Error loading application', err);
});

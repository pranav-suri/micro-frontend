import { Suspense, lazy } from 'react';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';

const Dashboard = lazy(() => import('dashboard/Module'));
const Analytics = lazy(() => import('analytics/Module'));
const Products = lazy(() => import('products/Module'));
const Orders = lazy(() => import('orders/Module'));

export function App() {
  return (
    <BrowserRouter>
      <div className="app">
        <nav style={{ padding: '1rem', background: '#f0f0f0' }}>
          <Link to="/" style={{ margin: '0 1rem' }}>
            Home
          </Link>
          <Link to="/dashboard" style={{ margin: '0 1rem' }}>
            Dashboard
          </Link>
          <Link to="/analytics" style={{ margin: '0 1rem' }}>
            Analytics
          </Link>
          <Link to="/products" style={{ margin: '0 1rem' }}>
            Products
          </Link>
          <Link to="/orders" style={{ margin: '0 1rem' }}>
            Orders
          </Link>
        </nav>

        <main style={{ padding: '2rem' }}>
          <Suspense fallback={<div>Loading...</div>}>
            <Routes>
              <Route path="/" element={<h1>Welcome to Shell App</h1>} />
              <Route path="/dashboard" element={<Dashboard />} />
              <Route path="/analytics" element={<Analytics />} />
              <Route path="/products" element={<Products />} />
              <Route path="/orders" element={<Orders />} />
            </Routes>
          </Suspense>
        </main>
      </div>
    </BrowserRouter>
  );
}

export default App;

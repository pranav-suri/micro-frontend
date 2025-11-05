import express from 'express';
import cors from 'cors';

const host = process.env.HOST ?? '0.0.0.0';
const port = process.env.PORT ? Number(process.env.PORT) : 3000;

const app = express();

// Enable CORS for all origins (you can restrict this in production)
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/', (req, res) => {
  res.send({ message: 'Products API is running', service: 'api-products' });
});

// API routes
app.get('/api/products', (req, res) => {
  res.json({
    message: 'Products API',
    products: [
      { id: 1, name: 'Laptop', price: 999.99, stock: 50 },
      { id: 2, name: 'Mouse', price: 29.99, stock: 200 },
      { id: 3, name: 'Keyboard', price: 79.99, stock: 100 },
    ],
  });
});

app.get('/api/products/:id', (req, res) => {
  const { id } = req.params;
  res.json({
    id: parseInt(id),
    name: 'Sample Product',
    price: 99.99,
    stock: 50,
  });
});

app.listen(port, host, () => {
  console.log(`[ ready ] http://${host}:${port}`);
});

// Deployement
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
  res.send({ message: 'Orders API is running', service: 'api-orders' });
});

// API routes
app.get('/api/orders', (req, res) => {
  res.json({
    message: 'Orders API',
    orders: [
      {
        id: 1,
        product: 'Laptop',
        quantity: 1,
        price: 999.99,
        status: 'delivered',
      },
      { id: 2, product: 'Mouse', quantity: 2, price: 29.99, status: 'pending' },
    ],
  });
});

app.get('/api/orders/:id', (req, res) => {
  const { id } = req.params;
  res.json({
    id: parseInt(id),
    product: 'Sample Product',
    quantity: 1,
    price: 99.99,
    status: 'delivered',
  });
});

app.listen(port, host, () => {
  console.log(`[ ready ] http://${host}:${port}`);
});

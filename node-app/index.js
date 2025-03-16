require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: process.env.POSTGRES_USER,
  host: 'data-stack-data-stack-1',
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: 5432,
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Test database connection
app.get('/test-db', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({
      status: 'Database connection successful',
      timestamp: result.rows[0].now
    });
  } catch (error) {
    res.status(500).json({
      status: 'Database connection failed',
      error: error.message
    });
  }
});

// Create a test table and insert a record
app.post('/create-test', async (req, res) => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS test_table (
        id SERIAL PRIMARY KEY,
        name TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    const result = await pool.query(
      'INSERT INTO test_table (name) VALUES ($1) RETURNING *',
      [req.body.name || 'test']
    );

    res.json({
      status: 'success',
      data: result.rows[0]
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      error: error.message
    });
  }
});

// Get all records
app.get('/records', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM test_table');
    res.json({
      status: 'success',
      data: result.rows
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      error: error.message
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
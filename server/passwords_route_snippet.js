require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const { cifrarTexto } = require('./encryption');

const app = express();
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

app.post('/passwords', async (req, res) => {
  const { usuario_id, servicio, clave_plana } = req.body;
  const id = parseInt(usuario_id, 10);

  if (!Number.isInteger(id)) {
    return res.status(400).json({
      success: false,
      message: 'usuario_id debe ser un entero válido',
    });
  }

  try {
    const claveCifrada = cifrarTexto(clave_plana);
    await pool.query(
      'INSERT INTO contraseñas (usuario_id, servicio, clave_cifrada) VALUES (?, ?, ?)',
      [id, servicio, claveCifrada]
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Error al guardar contraseña' });
  }
});

/*
Ejemplo de llamada fetch desde el navegador:
fetch('http://localhost:8000/passwords', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    usuario_id: 1,
    servicio: 'Correo',
    clave_plana: 'mi_clave_super_secreta',
  }),
})
  .then((r) => r.json())
  .then((data) => console.log(data));
*/

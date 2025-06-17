require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const { cifrarTexto, descifrarTexto } = require('./encryption');
const app = express();

app.use(express.json());

// Funciones de cifrado/descifrado

// Conexión BBDD
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// POST /register
app.post('/register', async (req, res) => {
  const { nombre, telefono, email, contrasena } = req.body;

  try {
    await pool.query(
      'INSERT INTO usuarios (nombre, telefono, email, contraseña) VALUES (?, ?, ?, ?)',
      [nombre, telefono, email, contrasena]
    );

    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Error al registrar usuario' });
  }
});

// POST /login
app.post('/login', async (req, res) => {
  // accept both `usuario` and `email` to be more robust
  const email = req.body.email || req.body.usuario;
  const { contrasena } = req.body;

  try {
    const [rows] = await pool.query(
      'SELECT id, contraseña FROM usuarios WHERE email = ?',
      [email]
    );

    if (rows.length === 0) {
      return res.status(200).json({ success: false, message: 'Usuario no encontrado' });
    }

    const usuario = rows[0];

    if (usuario.contraseña === contrasena) {
      res.json({ success: true, usuario_id: usuario.id });
    } else {
      res.json({ success: false, message: 'Contraseña incorrecta' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Error al procesar login' });
  }
});

// POST /passwords → guardar contraseña
app.post('/passwords', async (req, res) => {
  const { usuario_id, servicio, clave_plana } = req.body;
  const id = parseInt(usuario_id, 10);

  if (!Number.isInteger(id)) {
    return res
      .status(400)
      .json({ success: false, message: 'usuario_id debe ser un entero válido' });
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

// GET /passwords → obtener contraseñas de un usuario
app.get('/passwords', async (req, res) => {
  const usuarioId = req.query.usuario_id;

  try {
    const [rows] = await pool.query(
      'SELECT id, servicio, clave_cifrada FROM contraseñas WHERE usuario_id = ?',
      [usuarioId]
    );

    const contrasenas = rows.map((row) => ({
      id: row.id,
      servicio: row.servicio,
      clave_cifrada: row.clave_cifrada,
      clave_descifrada: descifrarTexto(row.clave_cifrada),
    }));

    res.json(contrasenas);
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Error al obtener contraseñas' });
  }
});

const PORT = process.env.PORT || 8000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en http://0.0.0.0:${PORT}`);
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

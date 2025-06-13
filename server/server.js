require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const crypto = require('crypto');
const app = express();

app.use(express.json());

// Cifrado
const algorithm = 'aes-256-cbc';
const secretKey = crypto
  .createHash('sha256')
  .update(String(process.env.ENCRYPTION_KEY || 'default_secret'))
  .digest('base64')
  .substr(0, 32);
const iv = Buffer.alloc(16, 0);

function cifrarTexto(texto) {
  const cipher = crypto.createCipheriv(algorithm, secretKey, iv);
  let encrypted = cipher.update(texto, 'utf8', 'base64');
  encrypted += cipher.final('base64');
  return encrypted;
}

function descifrarTexto(encryptedTexto) {
  const decipher = crypto.createDecipheriv(algorithm, secretKey, iv);
  let decrypted = decipher.update(encryptedTexto, 'base64', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}

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
  const { usuario_id, servicio } = req.body;
  const clave = req.body.clave || req.body.clave_plana;

  try {
    const claveCifrada = cifrarTexto(clave);

    await pool.query(
      'INSERT INTO contrasenas (usuario_id, servicio, clave_cifrada) VALUES (?, ?, ?)',
      [usuario_id, servicio, claveCifrada]
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
      'SELECT id, servicio, clave_cifrada FROM contrasenas WHERE usuario_id = ?',
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

const crypto = require('crypto');

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

module.exports = { cifrarTexto, descifrarTexto };

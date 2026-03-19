const path = require('path');

const rootDir = path.resolve(__dirname, '..', '..');

function normalizeOrigins(rawOrigins) {
  if (!rawOrigins || rawOrigins.trim() === '' || rawOrigins.trim() === '*') {
    return ['*'];
  }

  return rawOrigins
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);
}

module.exports = {
  nodeEnv: process.env.NODE_ENV || 'development',
  host: process.env.HOST || '0.0.0.0',
  port: Number(process.env.PORT) || 3000,
  corsOrigins: normalizeOrigins(process.env.CORS_ORIGINS),
  databaseUrl: process.env.DATABASE_URL || '',
  jwtSecret: process.env.JWT_SECRET || 'change-this-secret',
  jwtAccessExpiresIn:
    process.env.JWT_ACCESS_EXPIRES_IN || process.env.JWT_EXPIRES_IN || '15m',
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET || process.env.JWT_SECRET || 'change-this-secret',
  jwtRefreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '30d',
  rootDir,
};

const env = require('../config/env');
const prisma = require('../lib/prisma');

function hasPlaceholderDatabaseUrl(databaseUrl) {
  return (
    !databaseUrl ||
    databaseUrl.includes('mysql://USER:PASSWORD@') ||
    databaseUrl.includes('mysql://user:password@')
  );
}

function hasPlaceholderJwtSecret(jwtSecret) {
  return !jwtSecret || jwtSecret === 'any-strong-secret' || jwtSecret === 'change-this-secret';
}

function validateEnvironment() {
  if (hasPlaceholderDatabaseUrl(env.databaseUrl)) {
    throw new Error(
      'DATABASE_URL في backend/.env ما زالت placeholder. ضع user/password الحقيقيين لـ MySQL.',
    );
  }

  if (hasPlaceholderJwtSecret(env.jwtSecret)) {
    console.warn(
      'JWT_SECRET ما زال placeholder. الباك سيعمل، لكن يفضل تغييره قبل أي استخدام حقيقي.',
    );
  }

  if (hasPlaceholderJwtSecret(env.jwtRefreshSecret)) {
    console.warn(
      'JWT_REFRESH_SECRET ما زال placeholder. يفضل تغييره قبل أي استخدام حقيقي.',
    );
  }
}

async function ensureDatabaseConnection() {
  await prisma.$connect();
  await prisma.$queryRawUnsafe('SELECT 1 AS ok');
}

module.exports = {
  ensureDatabaseConnection,
  validateEnvironment,
};

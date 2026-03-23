const env = require('../config/env');

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
      'Database URL is missing or still placeholder. Set DATABASE_URL, MYSQL_URL, or Railway MySQL variables.',
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

function wait(delayMs) {
  return new Promise((resolve) => setTimeout(resolve, delayMs));
}

async function ensureDatabaseConnection(options = {}) {
  const prisma = require('../lib/prisma');
  const retries = options.retries ?? 5;
  const delayMs = options.delayMs ?? 3000;
  let lastError;

  for (let attempt = 1; attempt <= retries; attempt += 1) {
    try {
      await prisma.$connect();
      await prisma.$queryRawUnsafe('SELECT 1 AS ok');
      return;
    } catch (error) {
      lastError = error;
      const isLastAttempt = attempt === retries;
      console.error(
        `Database connection attempt ${attempt}/${retries} failed: ${error.message || error}`,
      );
      await prisma.$disconnect().catch(() => {});

      if (!isLastAttempt) {
        await wait(delayMs);
      }
    }
  }

  throw lastError;
}

module.exports = {
  ensureDatabaseConnection,
  validateEnvironment,
};

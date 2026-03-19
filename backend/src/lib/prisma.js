const { PrismaClient } = require('@prisma/client');
const { PrismaMariaDb } = require('@prisma/adapter-mariadb');

const env = require('../config/env');

const globalForPrisma = globalThis;

function createPrismaClient() {
  if (!env.databaseUrl) {
    throw new Error('DATABASE_URL is not configured. Add it to backend/.env first.');
  }

  const adapter = new PrismaMariaDb(env.databaseUrl);

  return new PrismaClient({
    adapter,
    log: ['error', 'warn'],
  });
}

const prisma =
  globalForPrisma.prisma ||
  createPrismaClient();

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}

module.exports = prisma;

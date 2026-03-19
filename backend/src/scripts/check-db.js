require('dotenv').config();

const env = require('../config/env');
const prisma = require('../lib/prisma');

function hasPlaceholderDatabaseUrl(databaseUrl) {
  return (
    !databaseUrl ||
    databaseUrl.includes('mysql://USER:PASSWORD@') ||
    databaseUrl.includes('mysql://user:password@')
  );
}

async function main() {
  if (hasPlaceholderDatabaseUrl(env.databaseUrl)) {
    console.error(
      'DATABASE_URL ما زالت placeholder. عدل backend/.env إلى بيانات MySQL الحقيقية أولًا.',
    );
    process.exit(1);
  }

  try {
    await prisma.$connect();
    await prisma.$queryRawUnsafe('SELECT 1 AS ok');
    console.log('Database connection is healthy.');
  } catch (error) {
    console.error('Database connection failed.');
    console.error(error);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect().catch(() => {});
  }
}

main();


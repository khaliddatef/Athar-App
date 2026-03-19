require('dotenv').config();

const app = require('./app');
const env = require('./config/env');
const prisma = require('./lib/prisma');
const { ensureDatabaseConnection, validateEnvironment } = require('./utils/startup');

let server;

async function startServer() {
  validateEnvironment();
  await ensureDatabaseConnection();

  server = app.listen(env.port, env.host, () => {
    const printableHost = env.host === '0.0.0.0' ? 'localhost' : env.host;
    console.log(`Sanad backend listening on http://${printableHost}:${env.port}`);
  });
}

function shutdown(signal) {
  console.log(`\nReceived ${signal}, shutting down gracefully...`);

  if (!server) {
    prisma.$disconnect().finally(() => process.exit(0));
    return;
  }

  server.close(() => {
    prisma.$disconnect().finally(() => process.exit(0));
  });
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

startServer().catch(async (error) => {
  console.error('Failed to start backend.');
  console.error(error.message || error);
  await prisma.$disconnect().catch(() => {});
  process.exit(1);
});

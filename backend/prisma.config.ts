import 'dotenv/config';
import { defineConfig } from 'prisma/config';

function normalizeEnvValue(value: string | undefined) {
  if (!value) {
    return '';
  }

  const trimmed = value.trim();

  if (
    trimmed.length >= 2 &&
    ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
      (trimmed.startsWith("'") && trimmed.endsWith("'")))
  ) {
    return trimmed.slice(1, -1).trim();
  }

  return trimmed;
}

function firstDefinedEnv(keys: string[]) {
  for (const key of keys) {
    const value = normalizeEnvValue(process.env[key]);

    if (value) {
      return value;
    }
  }

  return '';
}

function resolveDatabaseUrl() {
  const directUrl = firstDefinedEnv(['DATABASE_URL', 'MYSQL_URL', 'MYSQL_PUBLIC_URL']);

  if (directUrl) {
    return directUrl;
  }

  const host = firstDefinedEnv(['MYSQLHOST', 'MYSQL_HOST']);
  const port = firstDefinedEnv(['MYSQLPORT', 'MYSQL_PORT']) || '3306';
  const user = firstDefinedEnv(['MYSQLUSER', 'MYSQL_USER']);
  const password = firstDefinedEnv(['MYSQLPASSWORD', 'MYSQL_PASSWORD']);
  const database = firstDefinedEnv(['MYSQLDATABASE', 'MYSQL_DATABASE']);

  if (!host || !user || !database) {
    return '';
  }

  return `mysql://${encodeURIComponent(user)}:${encodeURIComponent(password)}@${host}:${port}/${encodeURIComponent(database)}`;
}

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
  },
  datasource: {
    url: resolveDatabaseUrl(),
  },
});

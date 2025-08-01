import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema.ts';

const pool = new Pool({
  connectionString: Deno.env.get('APPLICATION_DB'),
});

export const db = drizzle(pool, { schema });
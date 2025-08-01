import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema.ts';
import { sql } from 'drizzle-orm';

const connectionString = Deno.env.get('APPLICATION_DB');

if (!connectionString) {
  throw new Error('APPLICATION_DB environment variable is not set');
}

console.log('🔗 Database connection string:', connectionString.replace(/:[^:@]*@/, ':****@')); // Hide password in logs

// Parse connection string to determine if it's local or remote
const isLocalConnection = connectionString.includes('localhost') || connectionString.includes('127.0.0.1');

// Parse connection string to extract components
const url = new URL(connectionString);
const password = decodeURIComponent(url.password);

const pool = new Pool({
  host: url.hostname,
  port: parseInt(url.port),
  database: url.pathname.slice(1), // Remove leading slash
  user: url.username,
  password: password,
  ssl: isLocalConnection ? false : {
    rejectUnauthorized: false, // For development - adjust for production
  },
  // Add connection timeout and retry options
  connectionTimeoutMillis: 10000,
  idleTimeoutMillis: 30000,
  max: 20,
  // Add authentication options
  keepAlive: true,
  keepAliveInitialDelayMillis: 10000,
});

// Test the connection
pool.on('error', (err) => {
  console.error('❌ Unexpected error on idle client', err);
  process.exit(-1);
});

// Test connection on startup
pool.connect((err, client, release) => {
  if (err) {
    console.error('❌ Database connection failed:', err);
    console.error('Error details:', {
      code: (err as any).code,
      message: err.message,
      detail: (err as any).detail,
    });
    process.exit(-1);
  } else {
    console.log('✅ Database connection successful');
    release();
  }
});

export const db = drizzle(pool, { schema });

// Test function to verify database connectivity
export async function testDatabaseConnection() {
  try {
    const result = await db.execute(sql`SELECT 1 as test`);
    console.log('✅ Database query test successful:', result);
    
    // Also test if the tomra_events table exists
    try {
      const tableTest = await db.execute(sql`SELECT COUNT(*) FROM tomra_events`);
      console.log('✅ tomra_events table exists and is accessible');
    } catch (tableError) {
      console.error('❌ tomra_events table test failed:', tableError);
      console.log('💡 You may need to run database migrations');
    }
    
    return true;
  } catch (error) {
    console.error('❌ Database query test failed:', error);
    return false;
  }
}
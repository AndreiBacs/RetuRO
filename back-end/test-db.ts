import { load } from 'https://deno.land/std@0.208.0/dotenv/mod.ts';
import { Pool } from 'pg';

// Load environment variables
await load({ 
  envPath: '../env.dev',
  export: true 
});

const connectionString = Deno.env.get('APPLICATION_DB');

if (!connectionString) {
  console.error('❌ APPLICATION_DB environment variable is not set');
  Deno.exit(1);
}

console.log('🔗 Testing connection to:', connectionString.replace(/:[^:@]*@/, ':****@'));

// Parse connection string
const url = new URL(connectionString);
const password = decodeURIComponent(url.password);

// Test with different configurations
const configs = [
  { 
    name: 'Connection string with SSL disabled', 
    config: { connectionString, ssl: false }
  },
  { 
    name: 'Parsed connection with SSL disabled', 
    config: {
      host: url.hostname,
      port: parseInt(url.port),
      database: url.pathname.slice(1),
      user: url.username,
      password: password,
      ssl: false
    }
  },
  { 
    name: 'Parsed connection with SSL enabled', 
    config: {
      host: url.hostname,
      port: parseInt(url.port),
      database: url.pathname.slice(1),
      user: url.username,
      password: password,
      ssl: { rejectUnauthorized: false }
    }
  },
];

for (const config of configs) {
  console.log(`\n🧪 Testing ${config.name}...`);
  
  const pool = new Pool({
    ...config.config,
    connectionTimeoutMillis: 5000,
  });

  try {
    const client = await pool.connect();
    console.log(`✅ ${config.name} - Connection successful!`);
    await client.query('SELECT 1 as test');
    console.log(`✅ ${config.name} - Query successful!`);
    client.release();
    await pool.end();
    
    // If we get here, the connection worked
    console.log(`\n🎉 Success with ${config.name}!`);
    Deno.exit(0);
  } catch (error) {
    console.error(`❌ ${config.name} - Failed:`, (error as Error).message);
    if ((error as any).code) {
      console.error(`   Error code: ${(error as any).code}`);
    }
    await pool.end();
  }
}

console.error('\n❌ All connection attempts failed');
Deno.exit(1); 
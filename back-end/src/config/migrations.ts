import db from './db.ts';

export interface Migration {
  id: number;
  name: string;
  up: () => Promise<void>;
  down: () => Promise<void>;
}

// Create migrations table if it doesn't exist
async function createMigrationsTable() {
  try {
    await db.query(`
      CREATE TABLE IF NOT EXISTS migrations (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ` as any);
  } catch (error) {
    console.error("Error creating migrations table:", error);
    throw error;
  }
}

// Get executed migrations
async function getExecutedMigrations(): Promise<string[]> {
  try {
    const result = await db.query("SELECT name FROM migrations ORDER BY id" as any);
    return (result as any[]).map((row: any) => row.name);
  } catch (error) {
    console.error("Error getting executed migrations:", error);
    return [];
  }
}

// Record migration as executed
async function recordMigration(name: string) {
  try {
    await db.query(`INSERT INTO migrations (name) VALUES ('${name}')` as any);
  } catch (error) {
    console.error("Error recording migration:", error);
    throw error;
  }
}

// Run all pending migrations
export async function runMigrations() {
  try {
    await createMigrationsTable();
    
    const executedMigrations = await getExecutedMigrations();
    const pendingMigrations = migrations.filter(m => !executedMigrations.includes(m.name));
    
    if (pendingMigrations.length === 0) {
      console.log("✅ No pending migrations");
      return;
    }
    
    console.log(`🔄 Running ${pendingMigrations.length} pending migrations...`);
    
    for (const migration of pendingMigrations) {
      console.log(`📦 Running migration: ${migration.name}`);
      await migration.up();
      await recordMigration(migration.name);
      console.log(`✅ Completed migration: ${migration.name}`);
    }
    
    console.log("✅ All migrations completed successfully");
  } catch (error) {
    console.error("❌ Migration failed:", error);
    throw error;
  }
}

// Migration definitions
const migrations: Migration[] = [
  {
    id: 1,
    name: "001_create_users_table",
    up: async () => {
      await db.query(`
        CREATE TABLE IF NOT EXISTS users (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255) NOT NULL UNIQUE,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ` as any);
    },
    down: async () => {
      await db.query("DROP TABLE IF EXISTS users" as any);
    }
  },
  {
    id: 2,
    name: "002_create_tomra_triggers_table",
    up: async () => {
      await db.query(`
        CREATE TABLE IF NOT EXISTS tomra_triggers (
          id SERIAL PRIMARY KEY,
          trigger TEXT NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          processed_at TIMESTAMP NULL
        )
      ` as any);
    },
    down: async () => {
      await db.query("DROP TABLE IF EXISTS tomra_triggers" as any);
    }
  }
]; 
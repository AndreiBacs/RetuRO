import { Database, PostgresConnector } from "denodb";
import { TomraTrigger } from "../models/tomra_trigger.ts";
import { User } from "../models/user.ts";

const db = new Database(
  new PostgresConnector({
    host: Deno.env.get("POSTGRES_HOST") || "localhost",
    database: Deno.env.get("POSTGRES_DB") || "returo",
    username: Deno.env.get("POSTGRES_USER") || "returo",
    password: Deno.env.get("POSTGRES_PASSWORD") || "returo",
    port: parseInt(Deno.env.get("POSTGRES_PORT") || "5432"),
  })
);

// Register models
db.link([TomraTrigger, User]);

// Initialize database connection and sync models
export async function initializeDatabase() {
  try {
    await db.sync({ drop: false }); // Set drop: true only for development
    console.log("✅ Database connected and models synced successfully");
  } catch (error) {
    console.error("❌ Database initialization failed:", error);
    throw error;
  }
}

// Close database connection
export async function closeDatabase() {
  try {
    await db.close();
    console.log("✅ Database connection closed successfully");
  } catch (error) {
    console.error("❌ Error closing database connection:", error);
    throw error;
  }
}

// Health check for database
export async function checkDatabaseHealth() {
  try {
    await db.query("SELECT 1" as any);
    return { status: "healthy", message: "Database connection is working" };
  } catch (error) {
    return { 
      status: "unhealthy", 
      message: "Database connection failed", 
      error: error instanceof Error ? error.message : "Unknown error" 
    };
  }
}

export default db;

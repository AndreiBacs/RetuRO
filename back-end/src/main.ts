import { Application, Router, Context } from 'oak';
import { oakCors } from 'cors';
import { load } from 'https://deno.land/std@0.208.0/dotenv/mod.ts';
import userRoutes from './routes/userRoutes.ts';
import webhookRoutes from './routes/webhookRoutes.ts';
import { initializeDatabase, checkDatabaseHealth } from './config/db.ts';
import { runMigrations } from './config/migrations.ts';
import { seedDatabase, isDatabaseEmpty } from './config/seeds.ts';

// Load environment variables from env.dev file
await load({ 
  envPath: '../env.dev',
  export: true 
});

// Initialize database and run migrations
await initializeDatabase();
//await runMigrations();

// Seed database if empty (development only)
// if (Deno.env.get('NODE_ENV') === 'development') {
//   const isEmpty = await isDatabaseEmpty();
//   if (isEmpty) {
//     await seedDatabase();
//   }
// }

const app = new Application();
const router = new Router();

// CORS middleware
app.use(oakCors({
  origin: ['http://localhost:3000', 'http://localhost:5173'],
  credentials: true,
}));

// Logger middleware
app.use(async (ctx: Context, next) => {
  const start = Date.now();
  await next();
  const ms = Date.now() - start;
  console.log(`${ctx.request.method} ${ctx.request.url.pathname} - ${ms}ms`);
});

// Health check endpoint
router.get('/health', async (ctx: Context) => {
  const dbHealth = await checkDatabaseHealth();
  
  ctx.response.body = {
    status: dbHealth.status === 'healthy' ? 'ok' : 'error',
    timestamp: new Date().toISOString(),
    service: 'ReruRO Backend',
    version: '1.0.0',
    database: dbHealth
  };
});

// API routes
router.get('/api/hello', (ctx: Context) => {
  ctx.response.body = {
    message: 'Hello from ReruRO Backend!',
    timestamp: new Date().toISOString()
  };
});

// User routes
app.use(userRoutes.routes());
app.use(userRoutes.allowedMethods());

// Webhook routes
app.use(webhookRoutes.routes());
app.use(webhookRoutes.allowedMethods());

// Error handling middleware
app.use(async (ctx: Context, next) => {
  try {
    await next();
  } catch (err: unknown) {
    console.error(err);
    ctx.response.status = 500;
    ctx.response.body = {
      error: 'Internal Server Error',
      message: err instanceof Error ? err.message : 'Unknown error'
    };
  }
});

// 404 handler
app.use((ctx: Context) => {
  ctx.response.status = 404;
  ctx.response.body = {
    error: 'Not Found',
    message: 'The requested resource was not found'
  };
});

app.use(router.routes());
app.use(router.allowedMethods());

const port = parseInt(Deno.env.get('PORT') || '8000');
console.log(`🚀 ReruRO Backend server running on http://localhost:${port}`);

await app.listen({ port }); 
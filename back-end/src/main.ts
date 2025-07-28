import { Application, Router, Context } from 'oak';
import { oakCors } from 'cors';
import { load } from 'https://deno.land/std@0.208.0/dotenv/mod.ts';
import userRoutes from './routes/userRoutes.ts';

// Load environment variables
await load({ export: true });

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
router.get('/health', (ctx: Context) => {
  ctx.response.body = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'ReruRO Backend',
    version: '1.0.0'
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
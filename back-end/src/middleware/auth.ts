import { Context, Next } from 'oak';

export interface AuthenticatedContext extends Context {
  user?: {
    id: number;
    name: string;
    email: string;
  };
}

export async function authMiddleware(ctx: AuthenticatedContext, next: Next) {
  const authHeader = ctx.request.headers.get('Authorization');
  
  if (!authHeader) {
    ctx.response.status = 401;
    ctx.response.body = {
      success: false,
      error: 'Authorization header required'
    };
    return;
  }
  
  // Simple token validation - in a real app, you'd validate JWT tokens
  if (!authHeader.startsWith('Bearer ')) {
    ctx.response.status = 401;
    ctx.response.body = {
      success: false,
      error: 'Invalid authorization header format'
    };
    return;
  }
  
  const token = authHeader.substring(7);
  
  // Mock token validation - replace with real JWT validation
  if (token === 'valid-token') {
    ctx.user = {
      id: 1,
      name: 'Test User',
      email: 'test@example.com'
    };
    await next();
  } else {
    ctx.response.status = 401;
    ctx.response.body = {
      success: false,
      error: 'Invalid token'
    };
  }
}

export function requireAuth() {
  return authMiddleware;
} 
import { assertEquals, assertExists } from 'https://deno.land/std@0.208.0/assert/mod.ts';
import { UserController } from '../src/controllers/userController.ts';
import { Context } from 'oak';

// Mock context for testing
function createMockContext(method: string, path: string, body?: any): any {
  return {
    request: {
      method,
      url: new URL(`http://localhost:8000${path}`),
      body: () => Promise.resolve({ value: body }),
      headers: new Headers()
    },
    response: {
      status: 200,
      body: {},
      headers: new Headers()
    },
    params: {},
    state: {},
    app: {} as any,
    cookies: {} as any
  };
}

Deno.test('UserController - getAllUsers should return users array', async () => {
  const ctx = createMockContext('GET', '/api/users') as Context;
  
  await UserController.getAllUsers(ctx);
  
  assertEquals(ctx.response.status, 200);
  assertExists(ctx.response.body);
  assertEquals((ctx.response.body as any).success, true);
  assertEquals(Array.isArray((ctx.response.body as any).data), true);
});

Deno.test('UserController - getUserById should return user when found', async () => {
  const ctx = createMockContext('GET', '/api/users/1') as any;
  ctx.params = { id: '1' };
  
  await UserController.getUserById(ctx);
  
  assertEquals(ctx.response.status, 200);
  assertExists(ctx.response.body);
  assertEquals((ctx.response.body as any).success, true);
  assertEquals((ctx.response.body as any).data.id, 1);
});

Deno.test('UserController - getUserById should return 404 when user not found', async () => {
  const ctx = createMockContext('GET', '/api/users/999') as any;
  ctx.params = { id: '999' };
  
  await UserController.getUserById(ctx);
  
  assertEquals(ctx.response.status, 404);
  assertEquals((ctx.response.body as any).success, false);
});

Deno.test('UserController - createUser should create new user', async () => {
  const newUser = { name: 'Test User', email: 'test@example.com' };
  const ctx = createMockContext('POST', '/api/users', newUser) as Context;
  
  await UserController.createUser(ctx);
  
  assertEquals(ctx.response.status, 201);
  assertExists(ctx.response.body);
  assertEquals((ctx.response.body as any).success, true);
  assertEquals((ctx.response.body as any).data.name, newUser.name);
  assertEquals((ctx.response.body as any).data.email, newUser.email);
});

Deno.test('UserController - createUser should return 400 for invalid data', async () => {
  const invalidUser = { name: 'Test User' }; // Missing email
  const ctx = createMockContext('POST', '/api/users', invalidUser) as Context;
  
  await UserController.createUser(ctx);
  
  assertEquals(ctx.response.status, 400);
  assertEquals((ctx.response.body as any).success, false);
}); 
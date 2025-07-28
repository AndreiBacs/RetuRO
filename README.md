# ReruRO Backend

A modern Deno-based REST API backend for the ReruRO project.

## Features

- 🚀 **Fast & Modern**: Built with Deno and Oak framework
- 🔒 **Secure**: Authentication middleware included
- 📝 **TypeScript**: Full TypeScript support with strict typing
- 🧪 **Tested**: Unit tests included
- 🔄 **CORS**: Cross-origin resource sharing enabled
- 📊 **Health Check**: Built-in health monitoring endpoint

## Prerequisites

- [Deno](https://deno.land/) (version 1.35 or higher)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd RetuRO
```

2. Create environment file:
```bash
cp env.example .env
```

3. Install dependencies (Deno handles this automatically):
```bash
deno cache src/main.ts
```

## Running the Application

### Development Mode
```bash
deno task dev
```

### Production Mode
```bash
deno task start
```

### Running Tests
```bash
deno task test
```

### Code Formatting
```bash
deno task fmt
```

### Linting
```bash
deno task lint
```

## API Endpoints

### Health Check
- `GET /health` - Service health status

### Users
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Example Usage

```bash
# Health check
curl http://localhost:8000/health

# Get all users
curl http://localhost:8000/api/users

# Create a new user
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'

# Get user by ID
curl http://localhost:8000/api/users/1

# Update user
curl -X PUT http://localhost:8000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "John Updated", "email": "john.updated@example.com"}'

# Delete user
curl -X DELETE http://localhost:8000/api/users/1
```

## Project Structure

```
src/
├── main.ts              # Application entry point
├── controllers/         # Business logic controllers
│   └── userController.ts
├── routes/             # Route definitions
│   └── userRoutes.ts
├── middleware/          # Custom middleware
│   └── auth.ts
└── types/              # TypeScript type definitions
    └── index.ts
tests/
└── user.test.ts        # Unit tests
```

## Environment Variables

Create a `.env` file with the following variables:

```env
PORT=8000
NODE_ENV=development
API_VERSION=v1
CORS_ORIGIN=http://localhost:3000,http://localhost:5173
```

## Development

### Adding New Routes

1. Create a new controller in `src/controllers/`
2. Create route definitions in `src/routes/`
3. Import and use the routes in `src/main.ts`

### Adding Authentication

The project includes a basic authentication middleware. To use it:

```typescript
import { requireAuth } from './middleware/auth.ts';

// Protected route
router.get('/protected', requireAuth(), (ctx) => {
  // Route handler
});
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run tests and linting
6. Submit a pull request

## License

This project is licensed under the MIT License.
# RetuRO Backend

A modern Deno-based REST API backend for the RetuRO project, featuring webhook integration and PostgreSQL database support.

## 🚀 Features

- 🚀 **Fast & Modern**: Built with Deno and Oak framework
- 🔒 **Secure**: Authentication middleware and webhook signature verification
- 📝 **TypeScript**: Full TypeScript support with strict typing
- 🧪 **Tested**: Unit tests included
- 🔄 **CORS**: Cross-origin resource sharing enabled
- 📊 **Health Check**: Built-in health monitoring endpoints
- 🗄️ **Database**: PostgreSQL integration with Drizzle ORM
- 🔗 **Webhooks**: TOMRA webhook integration with signature verification
- 📋 **Migration**: Database schema management with Drizzle Kit

## 📋 Prerequisites

- [Deno](https://deno.land/) (version 1.35 or higher)
- [PostgreSQL](https://www.postgresql.org/) (version 12 or higher)

## 🛠️ Installation

1. **Set up the database:**
```bash
# Create PostgreSQL database
createdb returo
```

2. **Configure environment variables:**
```bash
# Copy the environment template from root
cp ../env.dev .env
# Edit .env with your database credentials and other settings
```

3. **Install dependencies:**
```bash
deno cache src/main.ts
```

4. **Run database migrations:**
```bash
deno task db:migrate
```

## 🏃‍♂️ Running the Application

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

## 🧹 Code Quality

```bash
# Format code
deno task fmt

# Check formatting
deno task fmt:check

# Lint code
deno task lint

# Fix linting issues
deno task lint:fix

# Type checking
deno task type-check
```

## 🗄️ Database Operations

```bash
# Generate schema migrations
deno task db:generate

# Run migrations
deno task db:migrate
```

## 🔗 API Endpoints

### Health Check
- `GET /health` - Service health status
- `GET /api/hello` - Hello endpoint

### Users
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Webhooks
- `POST /api/webhooks/tomra` - Handle TOMRA webhook events
- `GET /api/webhooks/tomra/health` - TOMRA webhook health check

### Example Usage

```bash
# Health check
curl http://localhost:8000/health

# Hello endpoint
curl http://localhost:8000/api/hello

# Get all users
curl http://localhost:8000/api/users

# Create a new user
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"fullName": "John Doe", "phone": "+1234567890"}'

# Get user by ID
curl http://localhost:8000/api/users/1

# Update user
curl -X PUT http://localhost:8000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{"fullName": "John Updated", "phone": "+1234567890"}'

# Delete user
curl -X DELETE http://localhost:8000/api/users/1

# TOMRA webhook health check
curl http://localhost:8000/api/webhooks/tomra/health
```

## 📁 Project Structure

```
back-end/
├── deno.json           # Deno configuration and tasks
├── deno.lock           # Dependency lock file
├── drizzle.config.ts   # Drizzle ORM configuration
├── drizzle/            # Database migrations
│   ├── 0000_mean_thor.sql
│   ├── 0001_user_permissions.sql
│   └── meta/
├── src/                # Source code
│   ├── main.ts         # Application entry point
│   ├── controllers/    # Business logic controllers
│   │   ├── userController.ts
│   │   └── webhookController.ts
│   ├── routes/         # Route definitions
│   │   ├── userRoutes.ts
│   │   └── webhookRoutes.ts
│   ├── middleware/     # Custom middleware
│   │   └── auth.ts
│   ├── db/            # Database configuration
│   │   ├── db.ts      # Database connection
│   │   └── schema.ts  # Database schema
│   ├── types/         # TypeScript type definitions
│   │   ├── index.ts
│   │   └── tomra.ts
│   └── utils/         # Utility functions
│       └── signatureVerification.ts
└── tests/             # Unit tests
    └── user.test.ts
```

## 🔧 Environment Variables

Create a `.env` file with the following variables:

```env
# Database
APPLICATION_DB=postgresql://username:password@localhost:5432/returo

# Server
PORT=8000
NODE_ENV=development
API_VERSION=v1

# CORS
CORS_ORIGIN=http://localhost:3000,http://localhost:5173

# TOMRA Webhook
TOMRA_WEBHOOK_SECRET=your_webhook_secret
```

## 🗄️ Database Schema

### Users Table
- `id` (serial, primary key)
- `fullName` (text)
- `phone` (varchar)

### TOMRA Events Table
- `id` (serial, primary key)
- `receivedOn` (timestamp, default now)
- `processedOn` (timestamp)
- `payload` (text)

## 🛠️ Development

### Adding New Routes

1. Create a new controller in `src/controllers/`
2. Create route definitions in `src/routes/`
3. Import and use the routes in `src/main.ts`

### Adding Database Models

1. Define the schema in `src/db/schema.ts`
2. Generate migrations: `deno task db:generate`
3. Run migrations: `deno task db:migrate`

### Adding Authentication

The project includes a basic authentication middleware. To use it:

```typescript
import { requireAuth } from './middleware/auth.ts';

// Protected route
router.get('/protected', requireAuth(), (ctx) => {
  // Route handler
});
```

### Webhook Integration

The project includes TOMRA webhook integration with signature verification:

```typescript
// Webhook signature verification
import { verifySignature } from './utils/signatureVerification.ts';

// Verify webhook signature
const isValid = verifySignature(payload, signature, secret);
```

## 📋 Available Tasks

- `deno task dev` - Start development server with hot reload
- `deno task start` - Start production server
- `deno task test` - Run tests
- `deno task test:watch` - Run tests in watch mode
- `deno task test:coverage` - Run tests with coverage
- `deno task fmt` - Format code
- `deno task fmt:check` - Check code formatting
- `deno task lint` - Lint code
- `deno task lint:fix` - Fix linting issues
- `deno task check` - Type check code
- `deno task type-check` - Type check without running
- `deno task cache` - Cache dependencies
- `deno task clean` - Clean coverage directory
- `deno task db:generate` - Generate database migrations
- `deno task db:migrate` - Run database migrations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run tests and linting: `deno task test && deno task lint`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License. 
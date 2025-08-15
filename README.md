# RetuRO

A modern recycling management platform with a Flutter mobile app and Deno backend API, specifically designed for the Romanian RVM (Reverse Vending Machine) market.

## 🏗️ Project Structure

This is a monorepo containing both the frontend mobile application and backend API:

```
RetuRO/
├── front-end/          # Flutter mobile application
│   └── retur_ro/      # Flutter project
│       ├── lib/
│       │   ├── pages/
│       │   │   ├── scanner/
│       │   │   │   ├── widgets/          # Scanner-specific widgets
│       │   │   │   │   ├── barcode_result_dialog.dart
│       │   │   │   │   ├── camera_controls.dart
│       │   │   │   │   ├── error_dialog.dart
│       │   │   │   │   └── scanner_overlay.dart
│       │   │   │   └── scanner_page.dart
│       │   │   ├── profile/
│       │   │   └── home_page.dart
│       │   ├── services/                 # App services
│       │   └── widgets/                  # Shared widgets
├── back-end/           # Deno REST API backend
│   ├── src/
│   │   ├── controllers/
│   │   ├── routes/
│   │   ├── db/
│   │   └── middleware/
│   ├── assets/                          # CSV data files
│   └── drizzle/                         # Database migrations
├── env.dev            # Environment configuration template
├── INSTALLATION.md    # Setup instructions
└── README.md         # This file
```

## 🚀 Quick Start

### Prerequisites

- [Flutter](https://flutter.dev/) (version 3.8.1 or higher)
- [Deno](https://deno.land/) (version 1.35 or higher)
- [PostgreSQL](https://www.postgresql.org/) (version 12 or higher)

### Setup

1. **Clone the repository:**
```bash
git clone <repository-url>
cd RetuRO
```

2. **Configure environment:**
```bash
cp env.dev .env
# Edit .env with your database credentials and settings
```

3. **Setup Backend:**
```bash
cd back-end
deno cache src/main.ts
deno task db:migrate
deno task db:seed
deno task dev
```

4. **Setup Frontend:**
```bash
cd front-end/retur_ro
flutter pub get
flutter run
```

## 📱 Frontend (Flutter)

The mobile application is built with Flutter and includes:

- 📷 **Barcode Scanner**: Camera-based scanning with custom overlay and controls
- 📍 **Location Services**: GPS tracking and geocoding
- 🌐 **HTTP Integration**: API communication with backend
- 📱 **Cross-platform**: iOS and Android support
- 🎨 **Modern UI**: Material Design with theme support
- 🔄 **Real-time Updates**: Live data synchronization

### Key Features

- **Scanner Widgets**: Modular scanner components including:
  - `BarcodeResultDialog`: Displays scan results with validation status
  - `ErrorDialog`: Handles scanner errors gracefully
  - `CameraControls`: Torch, camera switching, and auto-hide controls
  - `ScannerOverlay`: Custom scanning frame overlay

### Running the Mobile App

```bash
cd front-end/retur_ro
flutter pub get
flutter run
```

## 🔧 Backend (Deno)

The REST API is built with Deno and includes:

- 🚀 **Fast & Modern**: Deno runtime with Oak framework
- 🔒 **Secure**: Authentication and webhook signature verification
- 📝 **TypeScript**: Full TypeScript support with strict typing
- 🗄️ **Database**: PostgreSQL with Drizzle ORM
- 🔗 **Webhooks**: TOMRA integration with signature verification
- 🇷🇴 **Romanian Focus**: Specialized for Romanian RVM market

### Key Features

- **Database Seeding**: 72,000+ Romanian barcodes from official registry
- **CSV Processing**: Bulk data import with batch processing
- **Webhook Integration**: TOMRA webhook handling with signature verification
- **Type Safety**: Full TypeScript support with proper type inference

### Running the Backend

```bash
cd back-end
deno task dev          # Development mode
deno task start        # Production mode
deno task test         # Run tests
```

## 🔗 API Endpoints

### Health & Status
- `GET /health` - Service health status
- `GET /api/hello` - Hello endpoint

### Users
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Barcodes
- `POST /api/barcodes/check` - Validate barcode for recycling

### Webhooks
- `POST /api/webhooks/tomra` - Handle TOMRA webhook events
- `GET /api/webhooks/tomra/health` - TOMRA webhook health check

## 🛠️ Development

### Backend Development

```bash
cd back-end
deno task dev          # Start development server
deno task test         # Run tests
deno task fmt          # Format code
deno task lint         # Lint code
deno task db:generate  # Generate migrations
deno task db:migrate   # Run migrations
deno task db:seed      # Seed database
```

### Frontend Development

```bash
cd front-end/retur_ro
flutter pub get        # Install dependencies
flutter run            # Run on connected device
flutter test           # Run tests
flutter build apk      # Build Android APK
flutter build ios      # Build iOS app
```

## 📋 Environment Variables

Create a `.env` file with:

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
TOMRA_IP=34.140.242.111
```

## 🇷🇴 Romanian RVM Market Focus

This platform is specifically designed for the Romanian RVM market:

### Supported Producers
- **TOMRA ROMANIA** - Global leader in RVM solutions
- **RVM Systems România** - Local RVM manufacturer
- **Envipco România** - European factory producing RVMs locally
- **ValuePack România** - Romanian packaging solutions
- **RomCooling** - Romanian cooling solutions

### Data Sources
- **Romanian Packaging Registry** - 72,000+ official barcodes
- **Local Supermarkets** - Kaufland, Lidl locations
- **Real Addresses** - Accurate Romanian addresses

## 📚 Documentation

- [Backend API Documentation](./back-end/README.md) - Detailed backend documentation
- [Installation Guide](./INSTALLATION.md) - Complete setup instructions
- [Frontend Documentation](./front-end/retur_ro/README.md) - Mobile app documentation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run tests and linting
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
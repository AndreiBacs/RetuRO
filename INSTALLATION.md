# RetuRO Installation Guide

Complete setup instructions for the RetuRO recycling management platform.

## 📋 Prerequisites

### Backend Requirements
- [Deno](https://deno.land/) (version 1.35 or higher)
- [PostgreSQL](https://www.postgresql.org/) (version 12 or higher)

### Frontend Requirements
- [Flutter](https://flutter.dev/) (version 3.8.1 or higher)
- [Dart](https://dart.dev/) (version 3.8.1 or higher)
- Android Studio / Xcode (for mobile development)

## 🚀 Quick Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd RetuRO
```

### 2. Configure Environment
```bash
cp env.dev .env
# Edit .env with your database credentials and settings
```

### 3. Setup Backend
```bash
cd back-end
deno cache src/main.ts
deno task db:migrate
deno task dev
```

### 4. Setup Frontend
```bash
cd front-end/retur_ro
flutter pub get
flutter run
```

## 🔧 Detailed Installation

### Backend Setup

#### Install Deno

**Windows (PowerShell)**
```powershell
irm https://deno.land/x/install/install.ps1 | iex
```

**Windows (Chocolatey)**
```powershell
choco install deno
```

**Windows (Scoop)**
```powershell
scoop install deno
```

**macOS (Homebrew)**
```bash
brew install deno
```

**Linux/macOS (Shell)**
```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
```

#### Install PostgreSQL

**Windows**
- Download from [PostgreSQL website](https://www.postgresql.org/download/windows/)
- Or use Chocolatey: `choco install postgresql`

**macOS**
```bash
brew install postgresql
brew services start postgresql
```

**Linux (Ubuntu/Debian)**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### Setup Database
```bash
# Create database
createdb returo

# Or using psql
psql -U postgres
CREATE DATABASE returo;
\q
```

#### Configure Backend
```bash
cd back-end
cp ../env.dev .env
# Edit .env with your database credentials
deno cache src/main.ts
deno task db:migrate
```

### Frontend Setup

#### Install Flutter

**Windows**
- Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
- Add Flutter to PATH
- Run `flutter doctor`

**macOS**
```bash
brew install flutter
flutter doctor
```

**Linux**
```bash
# Download and extract Flutter
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz
tar xf flutter_linux_3.16.5-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

#### Setup Flutter Project
```bash
cd front-end/retur_ro
flutter pub get
flutter doctor
```

## 🏃‍♂️ Running the Application

### Backend Development
```bash
cd back-end
deno task dev
```

### Frontend Development
```bash
cd front-end/retur_ro
flutter run
```

### Running Tests

**Backend Tests**
```bash
cd back-end
deno task test
```

**Frontend Tests**
```bash
cd front-end/retur_ro
flutter test
```

## 🔧 Environment Configuration

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

## 🧪 Verification

### Backend Health Check
```bash
curl http://localhost:8000/health
```

### Frontend Verification
```bash
cd front-end/retur_ro
flutter doctor
flutter run
```

## 🔧 Troubleshooting

### Deno Issues
- **Deno not found**: Make sure Deno is installed and added to PATH
- **Permission errors**: Deno requires explicit permissions for network, file system, and environment access
- **Port already in use**: Change PORT in `.env` or kill the process using the port

### Flutter Issues
- **Flutter not found**: Add Flutter to your PATH
- **Android SDK issues**: Run `flutter doctor` and follow the instructions
- **iOS issues**: Make sure Xcode is installed and configured

### Database Issues
- **Connection refused**: Make sure PostgreSQL is running
- **Authentication failed**: Check database credentials in `.env`
- **Database not found**: Create the database using `createdb returo`

### Network Issues
- **CORS errors**: Update CORS_ORIGIN in `.env`
- **API connection failed**: Check if backend is running on correct port
- **Mobile device connection**: Make sure device and development machine are on same network

## 📱 Platform-Specific Setup

### Android Development
1. Install Android Studio
2. Install Android SDK
3. Create Android Virtual Device (AVD)
4. Run `flutter doctor` to verify setup

### iOS Development (macOS only)
1. Install Xcode from App Store
2. Install iOS Simulator
3. Accept Xcode license: `sudo xcodebuild -license accept`
4. Run `flutter doctor` to verify setup

### Web Development
1. Enable web support: `flutter config --enable-web`
2. Run: `flutter run -d chrome`

## 🚀 Production Deployment

### Backend Deployment
1. Build for production: `deno task start`
2. Use process manager like PM2 or systemd
3. Configure reverse proxy (nginx)
4. Set up SSL certificates

### Frontend Deployment
1. Build for target platform:
   - Android: `flutter build apk --release`
   - iOS: `flutter build ios --release`
   - Web: `flutter build web --release`
2. Deploy to appropriate platform (Play Store, App Store, web hosting)

## 📚 Next Steps

After successful installation:

1. **Explore the API**: Test endpoints using curl or Postman
2. **Run the mobile app**: Connect a device or use emulator
3. **Check documentation**: Read component-specific READMEs
4. **Start developing**: Make changes and see them in real-time

## 🤝 Getting Help

- Check the [main README](./README.md) for project overview
- Read [backend documentation](./back-end/README.md) for API details
- Read [frontend documentation](./front-end/retur_ro/README.md) for mobile app details
- Open an issue on GitHub for bugs or feature requests 
# Configuration System

This directory contains the configuration system for the RetuRO Flutter app.

## Overview

The configuration system allows you to easily manage different backend URLs and other configuration values for different environments (development, staging, production).

## Files

- `app_config.dart` - Contains configuration constants and helper methods
- `README.md` - This documentation file

## Usage

### Basic Usage

The configuration is automatically initialized when the app starts. The HTTP service will use the configured backend URL.

### Changing the Backend URL

#### Method 1: Modify AppConfig (Recommended)

Edit `lib/config/app_config.dart` and modify the `getBackendUrl()` method:

```dart
static String getBackendUrl() {
  // For development with physical device
  return devBackendUrlWithIP;
  
  // For local development
  // return devBackendUrl;
  
  // For staging
  // return stagingBackendUrl;
  
  // For production
  // return productionBackendUrl;
}
```

#### Method 2: Set URL at Runtime

You can also set the URL programmatically:

```dart
import 'package:retur_ro/services/config_service.dart';

// In your app initialization
ConfigService().setBaseUrl('http://your-custom-url:8000');
```

#### Method 3: Use Environment Variables (Advanced)

You can extend the configuration system to read from environment variables:

1. Add the `flutter_dotenv` package to your `pubspec.yaml`
2. Create `.env` files for different environments
3. Modify `AppConfig.getBackendUrl()` to read from environment variables

### Environment-Specific Configuration

The system is designed to support different environments:

- **Development**: `http://localhost:8000` (for emulator/simulator)
- **Development with Physical Device**: `http://172.20.10.2:8000` (or your machine's IP)
- **Staging**: `http://staging-api.returo.com`
- **Production**: `https://api.returo.com`

### Build Flavors (Advanced)

For more advanced configuration, you can create different build flavors:

1. Create different config files for each flavor
2. Use build-time constants to select the right configuration
3. Modify `AppConfig.getBackendUrl()` to use build-time constants

Example:
```dart
static String getBackendUrl() {
  // This would be set at build time
  const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  
  switch (environment) {
    case 'prod':
      return productionBackendUrl;
    case 'staging':
      return stagingBackendUrl;
    default:
      return devBackendUrl;
  }
}
```

## Migration from Hardcoded URL

The old hardcoded URL `http://172.20.10.2:8000` has been replaced with a configurable system. The default is now `http://localhost:8000`, which is more appropriate for most development scenarios.

If you need to use the old IP address (for example, when testing on a physical device), you can:

1. Use `AppConfig.devBackendUrlWithIP` in the `getBackendUrl()` method
2. Or call `ConfigService().setBaseUrl(AppConfig.devBackendUrlWithIP)` during app initialization

## Best Practices

1. **Never commit sensitive URLs to version control** - Use environment variables for production URLs
2. **Use meaningful names** - The configuration constants have descriptive names
3. **Document changes** - When adding new configuration options, update this README
4. **Test all environments** - Make sure your app works with different backend URLs
5. **Use HTTPS in production** - Always use secure URLs for production environments

# RetuRO Mobile App

A Flutter-based mobile application for the RetuRO recycling management platform, specifically designed for the Romanian RVM (Reverse Vending Machine) market.

## 📱 Features

- 📷 **Barcode Scanner**: Camera-based scanning with custom overlay and controls
- 📍 **Location Services**: GPS tracking and geocoding capabilities
- 🌐 **HTTP Integration**: API communication with backend services
- 📱 **Cross-platform**: iOS and Android support
- 🎨 **Modern UI**: Material Design components with theme support
- 🔄 **Real-time Updates**: Live data synchronization
- 🎯 **Scanner Controls**: Torch, camera switching, and auto-hide controls
- 🌙 **Theme Support**: Light and dark mode with theme-aware UI elements
- 🇷🇴 **Romanian Focus**: Specialized for Romanian recycling market

## 📋 Prerequisites

- [Flutter](https://flutter.dev/) (version 3.8.1 or higher)
- [Dart](https://dart.dev/) (version 3.8.1 or higher)
- Android Studio / Xcode (for mobile development)
- Physical device or emulator for testing

## 🛠️ Installation

1. **Install Flutter dependencies:**
```bash
flutter pub get
```

2. **Verify Flutter installation:**
```bash
flutter doctor
```

3. **Run the application:**
```bash
flutter run
```

## 🏃‍♂️ Running the Application

### Development Mode
```bash
flutter run
```

### Debug Mode
```bash
flutter run --debug
```

### Release Mode
```bash
flutter run --release
```

### Running Tests
```bash
flutter test
```

## 📁 Project Structure

```
lib/
├── main.dart              # Application entry point
├── api/                   # API integration
│   └── fake_api.dart     # Mock API for development
├── location_cache.dart    # Location caching service
├── services/              # App services
│   ├── http_service.dart  # HTTP client and API communication
│   ├── location_service.dart  # Location handling
│   └── theme_service.dart     # Theme management
├── pages/                 # Application pages
│   ├── home_page.dart     # Home screen
│   ├── profile/           # Profile-related pages
│   │   ├── dark_mode_page.dart
│   │   ├── profile_page.dart
│   │   └── settings_page.dart
│   ├── scanner/           # Scanner functionality
│   │   ├── scanner_page.dart
│   │   └── widgets/       # Scanner-specific widgets
│   │       ├── barcode_result_dialog.dart  # Scan result display
│   │       ├── camera_controls.dart        # Camera controls
│   │       ├── error_dialog.dart           # Error handling
│   │       └── scanner_overlay.dart        # Custom scanning overlay
│   └── search_page.dart   # Search functionality
└── widgets/               # Shared reusable widgets
    └── recycle_icon.dart  # Custom recycle icon widget
```

## 🔧 Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons
- `http`: HTTP client for API calls
- `geolocator`: Location services
- `geocoding`: Address geocoding
- `mobile_scanner`: Camera-based barcode scanning

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code linting

## 📱 Platform Support

### Android
- Minimum SDK: 21
- Target SDK: 33
- Supports Android 5.0 (API level 21) and higher
- Camera permissions for barcode scanning

### iOS
- Minimum iOS version: 11.0
- Supports iPhone and iPad
- Camera permissions for barcode scanning

### Web
- Modern web browsers
- Progressive Web App (PWA) support
- Limited camera support (may require HTTPS)

## 🛠️ Development

### Scanner Widgets

The scanner functionality is organized into modular widgets:

#### BarcodeResultDialog
- Displays scan results with validation status
- Shows barcode data and recycling eligibility
- Handles both valid and invalid barcode responses
- Includes error message display when needed

#### ErrorDialog
- Handles scanner errors gracefully
- Provides clear error messages to users
- Includes retry functionality

#### CameraControls
- Torch/flashlight control
- Camera switching (front/back)
- Auto-hide functionality for better UX
- Theme-aware styling

#### ScannerOverlay
- Custom scanning frame overlay
- Visual guide for barcode positioning
- Animated scanning indicators
- Responsive design for different screen sizes

### Adding New Pages

1. Create a new page in `lib/pages/`
2. Add navigation in `lib/main.dart`
3. Update routing as needed

### Adding API Integration

1. Create API service in `lib/services/`
2. Add HTTP client configuration
3. Implement error handling

### Adding Location Features

1. Use `geolocator` package for GPS
2. Use `geocoding` package for address conversion
3. Handle location permissions properly

### Adding Scanner Features

1. Use `mobile_scanner` package for camera access
2. Implement custom overlay with `CustomPainter`
3. Handle camera permissions and controls
4. Add theme-aware UI elements

### Code Quality

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Build for different platforms
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
```

## 🔧 Configuration

### Android Configuration
- Update `android/app/build.gradle.kts` for Android-specific settings
- Configure permissions in `android/app/src/main/AndroidManifest.xml`

### iOS Configuration
- Update `ios/Runner/Info.plist` for iOS-specific settings
- Configure permissions and capabilities

### Environment Variables
Create a `.env` file for environment-specific configuration:

```env
API_BASE_URL=http://localhost:8000
DEBUG_MODE=true
```

## 📱 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/
```

## 📊 Performance

### Performance Tips
- Use `const` constructors where possible
- Implement proper state management
- Optimize image loading
- Minimize widget rebuilds

### Memory Management
- Dispose controllers properly
- Use weak references where appropriate
- Monitor memory usage in development

## 🔒 Security

### Best Practices
- Validate all user inputs
- Use HTTPS for API calls
- Implement proper authentication
- Secure sensitive data storage

### Permissions
- Location permissions for GPS features
- Camera permissions for barcode scanning
- Storage permissions if required

## 🚀 Deployment

### Android Play Store
1. Build release APK/AAB
2. Sign with release keystore
3. Upload to Google Play Console

### iOS App Store
1. Build release IPA
2. Archive in Xcode
3. Upload to App Store Connect

### Web Deployment
1. Build web version
2. Deploy to hosting service
3. Configure domain and SSL

## 🇷🇴 Romanian Market Features

This app is specifically designed for the Romanian recycling market:

### Supported Features
- **Romanian Barcode Validation**: Integration with Romanian packaging registry
- **Local RVM Integration**: Support for Romanian RVM manufacturers
- **Romanian Addresses**: Proper handling of Romanian postal codes and addresses
- **Localization**: Romanian language support (planned)

### Data Sources
- **Romanian Packaging Registry**: 72,000+ official barcodes
- **Local Supermarkets**: Kaufland, Lidl, and other major chains
- **RVM Manufacturers**: TOMRA, RVM Systems, Envipco, ValuePack, RomCooling

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run tests: `flutter test`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

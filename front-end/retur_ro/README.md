# RetuRO Mobile App

A Flutter-based mobile application for the RetuRO recycling management platform.

## 📱 Features

- 📍 **Location Services**: GPS tracking and geocoding capabilities
- 🌐 **HTTP Integration**: API communication with backend services
- 📱 **Cross-platform**: iOS and Android support
- 🎨 **Modern UI**: Material Design components
- 🔄 **Real-time Updates**: Live data synchronization

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
├── location_service.dart  # Location services
└── pages/                # Application pages
    ├── home_page.dart     # Home screen
    ├── profile_page.dart  # User profile
    ├── search_page.dart   # Search functionality
    └── settings_page.dart # App settings
```

## 🔧 Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons
- `http`: HTTP client for API calls
- `geolocator`: Location services
- `geocoding`: Address geocoding

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code linting

## 📱 Platform Support

### Android
- Minimum SDK: 21
- Target SDK: 33
- Supports Android 5.0 (API level 21) and higher

### iOS
- Minimum iOS version: 11.0
- Supports iPhone and iPad

### Web
- Modern web browsers
- Progressive Web App (PWA) support

## 🛠️ Development

### Adding New Pages

1. Create a new page in `lib/pages/`
2. Add navigation in `lib/main.dart`
3. Update routing as needed

### Adding API Integration

1. Create API service in `lib/api/`
2. Add HTTP client configuration
3. Implement error handling

### Adding Location Features

1. Use `geolocator` package for GPS
2. Use `geocoding` package for address conversion
3. Handle location permissions properly

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
- Camera permissions if needed
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

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run tests: `flutter test`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

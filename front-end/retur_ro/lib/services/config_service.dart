import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  // Default configuration values
  static const String _defaultBaseUrl = 'http://localhost:8000';
  
  // Mutable configuration that can be set at runtime
  String _baseUrl = _defaultBaseUrl;

  /// Get the current backend base URL
  String get baseUrl => _baseUrl;

  /// Set the backend base URL
  /// This can be called during app initialization to configure the URL
  /// based on environment, build flavor, or user preferences
  void setBaseUrl(String url) {
    if (kDebugMode) {
      print('ConfigService: Setting base URL to $url');
    }
    _baseUrl = url;
  }

  /// Initialize configuration based on environment
  /// This method can be called during app startup to set up environment-specific config
  void initialize({String? baseUrl}) {
    if (baseUrl != null) {
      setBaseUrl(baseUrl);
    } else {
      // Try to get from environment variables or use defaults
      _initializeFromEnvironment();
    }
  }

  /// Initialize configuration from environment variables
  /// This can be extended to read from different sources based on build configuration
  void _initializeFromEnvironment() {
    // Use the app config to get the appropriate URL
    final url = AppConfig.getBackendUrl();
    setBaseUrl(url);
    
    if (kDebugMode) {
      print('ConfigService: Initialized with URL from AppConfig: $url');
    }
  }

  /// Reset to default configuration
  void reset() {
    _baseUrl = _defaultBaseUrl;
  }

  /// Get a string representation of the current configuration
  @override
  String toString() {
    return 'ConfigService(baseUrl: $_baseUrl)';
  }
}

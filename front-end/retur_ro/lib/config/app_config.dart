/// Application configuration constants
/// 
/// This file contains configuration constants that can be easily modified
/// for different environments (development, staging, production).
/// 
/// To use different configurations:
/// 1. Modify the values in this file
/// 2. Or use environment variables
/// 3. Or create different config files for different build flavors
class AppConfig {
  // Backend URLs for different environments
  static const String devBackendUrl = 'http://localhost:8000';
  static const String stagingBackendUrl = 'http://staging-api.returo.com';
  static const String productionBackendUrl = 'https://api.returo.com';
  
  // For development with physical devices, you might need the IP address
  static const String devBackendUrlWithIP = 'http://172.20.10.2:8000';
  
  // Default timeout values
  static const int defaultTimeoutSeconds = 30;
  static const int shortTimeoutSeconds = 10;
  
  // API version
  static const String apiVersion = 'v1';
  
  // Feature flags
  static const bool enableDebugLogging = true;
  static const bool enableAnalytics = false;
  
  /// Get the appropriate backend URL based on the current environment
  /// 
  /// This method can be extended to read from environment variables
  /// or build configuration to automatically select the right URL
  static String getBackendUrl() {
    // You can modify this logic based on your needs:
    // - Read from environment variables
    // - Use different values for debug/release builds
    // - Use build flavors
    
    // For now, return the development URL
    // In a real app, you might want to:
    // 1. Use environment variables
    // 2. Use build configuration
    // 3. Use different values for different build flavors
    
    return devBackendUrl;
  }
  
  /// Get the backend URL with IP address for physical device testing
  static String getBackendUrlWithIP() {
    return devBackendUrlWithIP;
  }
}

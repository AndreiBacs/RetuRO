import 'package:flutter_test/flutter_test.dart';
import 'package:retur_ro/services/config_service.dart';
import 'package:retur_ro/config/app_config.dart';

void main() {
  group('ConfigService', () {
    test('should initialize with default URL', () {
      final configService = ConfigService();
      configService.initialize();
      
      expect(configService.baseUrl, equals(AppConfig.getBackendUrl()));
    });

    test('should allow setting custom URL', () {
      final configService = ConfigService();
      const customUrl = 'http://custom-server:9000';
      
      configService.setBaseUrl(customUrl);
      
      expect(configService.baseUrl, equals(customUrl));
    });

    test('should reset to default URL', () {
      final configService = ConfigService();
      configService.setBaseUrl('http://custom-server:9000');
      configService.reset();
      
      expect(configService.baseUrl, equals(AppConfig.devBackendUrl));
    });

    test('should initialize with custom URL', () {
      final configService = ConfigService();
      const customUrl = 'http://custom-server:9000';
      
      configService.initialize(baseUrl: customUrl);
      
      expect(configService.baseUrl, equals(customUrl));
    });
  });

  group('AppConfig', () {
    test('should return development URL by default', () {
      final url = AppConfig.getBackendUrl();
      expect(url, equals(AppConfig.devBackendUrl));
    });

    test('should return IP URL for physical device testing', () {
      final url = AppConfig.getBackendUrlWithIP();
      expect(url, equals(AppConfig.devBackendUrlWithIP));
    });

    test('should have valid URL constants', () {
      expect(AppConfig.devBackendUrl, isNotEmpty);
      expect(AppConfig.stagingBackendUrl, isNotEmpty);
      expect(AppConfig.productionBackendUrl, isNotEmpty);
      expect(AppConfig.devBackendUrlWithIP, isNotEmpty);
    });
  });
}

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:retur_ro/location_service.dart';

class LocationCache {
  static final LocationCache _instance = LocationCache._internal();
  factory LocationCache() => _instance;
  LocationCache._internal();

  final LocationService _locationService = LocationService();

  final ValueNotifier<Position?> position = ValueNotifier(null);
  final ValueNotifier<String?> address = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);

  Future<void> getLocation({bool forceRefresh = false}) async {
    if (!forceRefresh && position.value != null) {
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      final pos = await _locationService.determinePosition();
      final addr = await _locationService.getAddressFromPosition(pos);
      position.value = pos;
      address.value = addr;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

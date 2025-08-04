import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  Future<String> getAddressFromPosition(Position position) async {
    try {
      debugPrint('Getting address from position: $position');
      debugPrint('Running on web: $kIsWeb');

      if (kIsWeb) {
        debugPrint('Using web-specific geocoding approach...');
        return await _getAddressForWeb(position);
      }

      debugPrint('Calling placemarkFromCoordinates...');
      List<Placemark> placemarks =
          await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint('placemarkFromCoordinates timed out after 10 seconds');
              return <Placemark>[];
            },
          );
      debugPrint(
        'placemarkFromCoordinates completed. Found ${placemarks.length} placemarks',
      );

      // Check if placemarks list is empty
      if (placemarks.isEmpty) {
        debugPrint('No placemarks found, trying alternative method...');
        return await _getAddressAlternative(position);
      }

      Placemark place = placemarks[0];
      debugPrint('First placemark: $place');

      // Build address string with null safety
      List<String> addressParts = [];

      if (place.street != null && place.street!.isNotEmpty) {
        addressParts.add(place.street!);
        debugPrint('Added street: ${place.street}');
      }
      if (place.locality != null && place.locality!.isNotEmpty) {
        addressParts.add(place.locality!);
        debugPrint('Added locality: ${place.locality}');
      }
      if (place.postalCode != null && place.postalCode!.isNotEmpty) {
        addressParts.add(place.postalCode!);
        debugPrint('Added postalCode: ${place.postalCode}');
      }
      if (place.country != null && place.country!.isNotEmpty) {
        addressParts.add(place.country!);
        debugPrint('Added country: ${place.country}');
      }

      // If no address parts were found, return a default message
      if (addressParts.isEmpty) {
        debugPrint('No address parts found, trying alternative method...');
        return await _getAddressAlternative(position);
      }

      String result = addressParts.join(", ");
      debugPrint('Final address: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint('Error in getAddressFromPosition: $e');
      debugPrint('Stack trace: $stackTrace');
      return await _getAddressAlternative(position);
    }
  }

  Future<String> _getAddressForWeb(Position position) async {
    try {
      debugPrint('Using web-specific geocoding...');

      // For web, we'll use a simpler approach that works better
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> parts = [];

        if (place.name != null && place.name!.isNotEmpty) {
          parts.add(place.name!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          parts.add(place.locality!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          parts.add(place.country!);
        }

        if (parts.isNotEmpty) {
          return parts.join(", ");
        }
      }

      // If primary method fails, try alternative
      debugPrint('Primary web geocoding failed, trying alternative...');
      return await _getAddressForWebAlternative(position);
    } catch (e) {
      debugPrint('Web geocoding failed: $e');
      return await _getAddressForWebAlternative(position);
    }
  }

  Future<String> _getAddressForWebAlternative(Position position) async {
    try {
      debugPrint('Trying alternative web geocoding method...');

      // Use a different approach for web - try to get location from coordinates
      List<Location> locations = await locationFromAddress(
        '${position.latitude}, ${position.longitude}',
      );

      if (locations.isNotEmpty) {
        return "Location found via coordinates";
      }

      return "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
    } catch (e) {
      debugPrint('Alternative web geocoding also failed: $e');
      return "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
    }
  }

  Future<String> _getAddressAlternative(Position position) async {
    try {
      debugPrint('Trying alternative geocoding method...');
      List<Location> locations =
          await locationFromAddress(
            '${position.latitude}, ${position.longitude}',
          ).timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              debugPrint('Alternative geocoding timed out');
              return <Location>[];
            },
          );

      if (locations.isNotEmpty) {
        return "Location found via alternative method";
      }

      return "Address not available";
    } catch (e) {
      debugPrint('Alternative geocoding also failed: $e');
      return "Address not available";
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:retur_ro/api/fake_api.dart';
import 'package:retur_ro/location_cache.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final LocationCache _locationCache = LocationCache();
  final MapController _mapController = MapController();

  bool _isBottomSheetExpanded = false;
  bool _isBottomSheetCollapsed = false;
  VoidCallback? _positionListener;

  // Add state variables for places data
  List<String> _places = [];
  bool _isLoadingPlaces = true;
  String? _placesError;

  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_updateBottomSheetState);
    // Initial location fetch, if not already loaded
    _locationCache.getLocation();

    // Fetch places data on initialization
    _fetchPlacesData();

    // Listen for position changes and move map
    _positionListener = () {
      final position = _locationCache.position.value;
      if (position != null) {
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          13.0,
        );
      }
    };
    _locationCache.position.addListener(_positionListener!);

    _alignPositionOnUpdate = AlignOnUpdate.always;
    _alignPositionStreamController = StreamController<double?>();
  }

  // Add method to fetch places data
  Future<void> _fetchPlacesData() async {
    try {
      setState(() {
        _isLoadingPlaces = true;
        _placesError = null;
      });

      final places = await FakeApi.searchAddresses('a');

      setState(() {
        _places = places.toList();
        _isLoadingPlaces = false;
      });
    } catch (e) {
      setState(() {
        _placesError = e.toString();
        _isLoadingPlaces = false;
      });
    }
  }

  void _updateBottomSheetState() {
    final isExpanded = _sheetController.size > 0.3;
    final isCollapsed =
        _sheetController.size <= 0.01; // Detect when fully collapsed

    if (isExpanded != _isBottomSheetExpanded ||
        isCollapsed != _isBottomSheetCollapsed) {
      setState(() {
        _isBottomSheetExpanded = isExpanded;
        _isBottomSheetCollapsed = isCollapsed;
      });
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_updateBottomSheetState);
    if (_positionListener != null) {
      _locationCache.position.removeListener(_positionListener!);
    }
    _sheetController.dispose();
    _mapController.dispose();
    _alignPositionStreamController.close();
    super.dispose();
  }

  void _toggleBottomSheet() {
    final targetSize = _isBottomSheetExpanded ? 0.13 : 0.6;
    _sheetController.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _expandBottomSheet() {
    _sheetController.animateTo(
      0.25,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(
              _locationCache.position.value?.latitude ?? 44.4268,
              _locationCache.position.value?.longitude ?? 26.1025,
            ), // Bucharest coordinates
            initialZoom: 15,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture && _alignPositionOnUpdate != AlignOnUpdate.never) {
                setState(() {
                  _alignPositionOnUpdate = AlignOnUpdate.never;
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.retur_ro',
            ),
            CurrentLocationLayer(
              alignPositionStream: _alignPositionStreamController.stream,
              alignPositionOnUpdate: _alignPositionOnUpdate,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _alignPositionOnUpdate = AlignOnUpdate.always;
                    });
                    _alignPositionStreamController.add(20);
                  },
                  child: _alignPositionOnUpdate == AlignOnUpdate.always
                      ? const Icon(Icons.my_location)
                      : const Icon(Icons.location_searching),
                ),
              ),
            ),
            RichAttributionWidget(
              showFlutterMapAttribution: false,
              alignment: AttributionAlignment.bottomLeft,
              attributions: [
                // Suggested attribution for the OpenStreetMap public tile server
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                    Uri.parse('https://openstreetmap.org/copyright'),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Floating action button to expand sheet when collapsed
        if (_isBottomSheetCollapsed)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _expandBottomSheet,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
        DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: 0.25,
          minChildSize: 0,
          maxChildSize: 1,
          expand: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: _locationCache.isLoading,
                          builder: (context, isLoading, child) {
                            return IconButton(
                              icon: Icon(
                                Icons.location_on,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () => _locationCache.getLocation(
                                      forceRefresh: true,
                                    ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Location',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              ValueListenableBuilder<String?>(
                                valueListenable: _locationCache.address,
                                builder: (context, address, child) {
                                  return Text(
                                    address ?? 'Loading...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _toggleBottomSheet,
                          icon: Icon(
                            _isBottomSheetExpanded
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nearby Places',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_isLoadingPlaces)
                          const Center(child: CircularProgressIndicator())
                        else if (_placesError != null)
                          Center(
                            child: Text('Error fetching places: $_placesError'),
                          )
                        else
                          Column(
                            children: _places
                                .map(
                                  (place) => _buildPlaceItem(
                                    place,
                                    '0.2 km away',
                                    Icons.coffee,
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlaceItem(String name, String distance, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  distance,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward,
            size: 16,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

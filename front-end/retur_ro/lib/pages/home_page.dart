import 'package:flutter/material.dart';
import 'package:retur_ro/api/fake_api.dart';
import 'package:retur_ro/location_cache.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final LocationCache _locationCache = LocationCache();
  bool _isBottomSheetExpanded = false;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_updateBottomSheetState);
    // Initial location fetch, if not already loaded
    _locationCache.getLocation();
  }

  void _updateBottomSheetState() {
    final isExpanded = _sheetController.size > 0.3;
    if (isExpanded != _isBottomSheetExpanded) {
      setState(() {
        _isBottomSheetExpanded = isExpanded;
      });
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_updateBottomSheetState);
    _sheetController.dispose();
    super.dispose();
  }

  void _toggleBottomSheet() {
    final targetSize = _isBottomSheetExpanded ? 0.25 : 0.6;
    _sheetController.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.home, size: 64, color: Colors.deepPurple),
              SizedBox(height: 16),
              Text(
                'Home Page',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Welcome to the home page!', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: 0.25,
          minChildSize: 0.25,
          maxChildSize: 0.6,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.7),
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
                        FutureBuilder<Iterable<String>>(
                          future: FakeApi.searchAddresses('a'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error fetching data'),
                              );
                            }
                            final places = snapshot.data!.toList();
                            return Column(
                              children: places
                                  .map(
                                    (place) => _buildPlaceItem(
                                      place,
                                      '0.2 km away',
                                      Icons.coffee,
                                    ),
                                  )
                                  .toList(),
                            );
                          },
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
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
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
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

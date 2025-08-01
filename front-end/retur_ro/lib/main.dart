import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Bar Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Navigation Bar Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _bottomSheetController;
  late Animation<double> _bottomSheetAnimation;
  bool _isBottomSheetExpanded = false;
  double _dragStartY = 0;
  double _currentDragOffset = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _bottomSheetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bottomSheetAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bottomSheetController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleBottomSheet() {
    setState(() {
      _isBottomSheetExpanded = !_isBottomSheetExpanded;
      if (_isBottomSheetExpanded) {
        _bottomSheetController.forward();
      } else {
        _bottomSheetController.reverse();
      }
    });
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _currentDragOffset = 0;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _currentDragOffset = details.globalPosition.dy - _dragStartY;

    // Limit drag to reasonable bounds
    if (_isBottomSheetExpanded) {
      _currentDragOffset = _currentDragOffset.clamp(-100, 200);
    } else {
      _currentDragOffset = _currentDragOffset.clamp(-200, 100);
    }
  }

  void _onDragEnd(DragEndDetails details) {
    // Determine if we should expand or collapse based on drag velocity and distance
    double velocity = details.velocity.pixelsPerSecond.dy;
    double threshold = 50; // pixels

    if (_isBottomSheetExpanded) {
      // Currently expanded - check if we should collapse
      if (_currentDragOffset > threshold || velocity > 500) {
        setState(() {
          _isBottomSheetExpanded = false;
          _bottomSheetController.reverse();
        });
      } else {
        // Snap back to expanded
        _bottomSheetController.forward();
      }
    } else {
      // Currently collapsed - check if we should expand
      if (_currentDragOffset < -threshold || velocity < -500) {
        setState(() {
          _isBottomSheetExpanded = true;
          _bottomSheetController.forward();
        });
      } else {
        // Snap back to collapsed
        _bottomSheetController.reverse();
      }
    }

    _currentDragOffset = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _bottomSheetAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    80 * (1 - _bottomSheetAnimation.value) + _currentDragOffset,
                  ),
                  child: GestureDetector(
                    onPanStart: _onDragStart,
                    onPanUpdate: _onDragUpdate,
                    onPanEnd: _onDragEnd,
                    child: Container(
                      height: _isBottomSheetExpanded ? 400 : 200,
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
                      child: Column(
                        children: [
                          // Handle bar
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // Header
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(
                                        '123 Main Street, City, State',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.7),
                                        ),
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nearby Places',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildPlaceItem(
                                    'Coffee Shop',
                                    '0.2 km away',
                                    Icons.coffee,
                                  ),
                                  _buildPlaceItem(
                                    'Restaurant',
                                    '0.5 km away',
                                    Icons.restaurant,
                                  ),
                                  _buildPlaceItem(
                                    'Gas Station',
                                    '0.8 km away',
                                    Icons.local_gas_station,
                                  ),
                                  _buildPlaceItem(
                                    'Shopping Mall',
                                    '1.2 km away',
                                    Icons.shopping_bag,
                                  ),
                                  _buildPlaceItem(
                                    'Park',
                                    '1.5 km away',
                                    Icons.park,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
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

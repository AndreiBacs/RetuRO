import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/scanner/scanner_page.dart';
import 'pages/profile/profile_page.dart';
import 'widgets/recycle_icon.dart';
import 'services/theme_service.dart';
import 'services/config_service.dart';

void main() {
  // Initialize configuration service
  ConfigService().initialize();
  
  // Optional: Override the default URL if needed
  // For example, if you're testing on a physical device and need the IP address:
  // ConfigService().setBaseUrl(AppConfig.devBackendUrlWithIP);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Return IT',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green.shade800,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green.shade800,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeService.themeMode,
            debugShowCheckedModeBanner: false,
            home: const MyHomePage(title: 'Return IT'),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    ScannerPage(),
    ProfilePage(),
  ];

  static const List<String> _titles = <String>[
    'Return IT',
    'Search',
    'Scanner',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_titles[_selectedIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RecycleIcon(
              size: 28.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

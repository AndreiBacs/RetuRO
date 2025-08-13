import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class DarkModePage extends StatefulWidget {
  const DarkModePage({super.key});

  @override
  State<DarkModePage> createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Mode'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme mode selector
          Consumer<ThemeService>(
            builder: (context, themeService, child) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildThemeModeOption(
                        context,
                        themeService,
                        ThemeMode.light,
                        'Light',
                        'Always use light theme',
                        Icons.light_mode,
                      ),
                      _buildThemeModeOption(
                        context,
                        themeService,
                        ThemeMode.dark,
                        'Dark',
                        'Always use dark theme',
                        Icons.dark_mode,
                      ),
                      _buildThemeModeOption(
                        context,
                        themeService,
                        ThemeMode.system,
                        'System',
                        'Follow system settings',
                        Icons.brightness_auto,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeOption(
    BuildContext context,
    ThemeService themeService,
    ThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = themeService.themeMode == mode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            )
          : null,
      onTap: () {
        themeService.setThemeMode(mode);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Theme changed to $title mode')));
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dark_mode_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Settings options
          _buildSettingsOption(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications settings coming soon!'),
                ),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Change app language',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language settings coming soon!')),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Toggle dark/light theme',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DarkModePage()),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.location_on,
            title: 'Location Services',
            subtitle: 'Manage location permissions',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location settings coming soon!')),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.security,
            title: 'Privacy & Security',
            subtitle: 'Manage privacy settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings coming soon!')),
              );
            },
          ),
          _buildSettingsOption(
            context,
            icon: Icons.storage,
            title: 'Storage & Data',
            subtitle: 'Manage app data and cache',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Storage settings coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}

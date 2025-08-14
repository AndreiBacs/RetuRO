import 'package:flutter/material.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Profile header
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'user@example.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Navigate to edit profile page
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit Profile coming soon!')),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  tooltip: 'Edit Profile',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Profile options
        _buildProfileOption(
          context,
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'Configure app preferences',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
        _buildProfileOption(
          context,
          icon: Icons.history,
          title: 'Recycling History',
          subtitle: 'View your past recycling activities',
          onTap: () {
            // TODO: Navigate to recycling history page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recycling History coming soon!')),
            );
          },
        ),
        _buildProfileOption(
          context,
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {
            // TODO: Navigate to help page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help & Support coming soon!')),
            );
          },
        ),
        _buildProfileOption(
          context,
          icon: Icons.info,
          title: 'About',
          subtitle: 'App information and version',
          onTap: () {
            // TODO: Navigate to about page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('About page coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileOption(
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

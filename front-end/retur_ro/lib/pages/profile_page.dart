import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person, size: 64, color: Colors.deepPurple),
          SizedBox(height: 16),
          Text(
            'Profile Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Your profile information goes here!',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
} 
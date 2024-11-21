import 'package:flutter/material.dart';

class SettingsProfileScreen extends StatelessWidget {
  static const String name = 'settings-profile';

  const SettingsProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: Center(
        child: Text('Profile Settings'),
      ),
    );
  }
}

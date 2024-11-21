import 'package:bookie/config/menu/settings_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  static const String name = 'settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
          child: Column(
            children: [
              ...settingsMenuItems.map((e) => ListTile(
                  title: Text(e.title),
                  subtitle: e.subTitle != null ? Text(e.subTitle ?? '') : null,
                  leading: Icon(e.icon),
                  onTap: () {
                    context.go(e.link ?? '');
                  })),
            ],
          ),
        ));
  }
}

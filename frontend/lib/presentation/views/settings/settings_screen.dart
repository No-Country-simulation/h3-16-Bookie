import 'package:bookie/config/auth/auth0.dart';
import 'package:bookie/config/menu/settings_menu.dart';
import 'package:bookie/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  static const String name = 'settings';
  final AuthService authService = AuthService();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    if (e.title == "Cerrar sesión") {
                      ref.read(usersProvider.notifier).setIsLoaded();
                      authService.logout(context);
                    } else {
                      context.push(e.link ?? '');
                    }
                  })),
            ],
          ),
        ));
  }
}

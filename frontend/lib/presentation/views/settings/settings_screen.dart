import 'package:bookie/config/auth/auth0.dart';
import 'package:bookie/config/menu/settings_menu.dart';
import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:bookie/presentation/providers/favorite_provider.dart';
import 'package:bookie/presentation/providers/read_provider.dart';
import 'package:bookie/presentation/providers/stories_user_provider.dart';
import 'package:bookie/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  static const String name = 'settings';
  final AuthService authService = AuthService();

  SettingsScreen({super.key});

  // Al cerrar sesión
  void logout(BuildContext context, WidgetRef ref) {
    ref.read(usersProvider.notifier).setIsLoaded();
    ref.read(storiesUserProvider.notifier).clearStoriesOnLogout();
    ref.read(favoriteProvider.notifier).clearStoriesOnLogout();
    ref.read(readProvider.notifier).clearReadersOnLogout();
    authService.logout(context); // Lógica adicional para cerrar sesión
  }

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
                  onTap: () async {
                    if (e.title == "Perfil de usuario") {
                      final userId =
                          await SharedPreferencesKeys.getCredentials()
                              .then((value) => int.parse(value.id ?? '0'));

                      context.push(e.link ?? '', extra: {'userId': userId});
                      return;
                    }

                    if (e.title == "Cerrar sesión") {
                      logout(context, ref);
                    } else {
                      context.push(e.link ?? '');
                    }
                  })),
            ],
          ),
        ));
  }
}

import 'package:bookie/presentation/views/create_history/create_history_screen.dart';
import 'package:bookie/presentation/views/favorites/favorites_screen.dart';
import 'package:bookie/presentation/views/feed/feed_screen.dart';
import 'package:bookie/presentation/views/map_histories/map_histories_example_3d.dart';
import 'package:bookie/presentation/views/settings/settings_screen.dart';
import 'package:bookie/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Contenedor de pantalla de inicio
        index: pageIndex, // Índice de la página actual
        children: [
          FeedScreen(),
          MapHistories3D(),
          CreateHistoryScreen(),
          FavoritesScreen(),
          SettingsScreen(),
        ],
      ), // Contenedor de pantalla de inicio
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}

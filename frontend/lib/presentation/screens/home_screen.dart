import 'package:bookie/presentation/views/story/create_story_screen.dart';
import 'package:bookie/presentation/views/favorites/favorites_screen.dart';
import 'package:bookie/presentation/views/home-first/home_first.dart';
import 'package:bookie/presentation/views/map/map_stories_google_maps.dart';
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
          HomeFirstScreen(),
          MapStoriesGoogleMaps(),
          CreateHistoryScreen(),
          FavoritesScreen(),
          SettingsScreen(),
        ],
      ), // Contenedor de pantalla de inicio
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}

import 'package:bookie/presentation/screens/map_screen.dart';
import 'package:bookie/presentation/views/story/create_story_screen.dart';
import 'package:bookie/presentation/views/favorites/favorites_screen.dart';
import 'package:bookie/presentation/views/home-first/home_first.dart';
import 'package:bookie/presentation/views/settings/settings_screen.dart';
import 'package:bookie/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';

  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            // Actualiza el estado con el índice de la página actual
            _currentPageIndex = index;
          });
        },
        physics:
            NeverScrollableScrollPhysics(), // Desactiva el desplazamiento por gestos
        children: [
          HomeFirstScreen(),
          MapScreen(),
          CreateHistoryScreen(),
          FavoritesScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar:
          CustomBottomNavigation(currentIndex: _currentPageIndex),
    );
  }
}

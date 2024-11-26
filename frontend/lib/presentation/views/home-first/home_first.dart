import 'package:bookie/presentation/views/home-first/home_first_search.dart';
import 'package:flutter/material.dart';
import 'package:bookie/presentation/widgets/navbar/navbar_homepage.dart';
import 'package:bookie/presentation/widgets/section/home_first/hero_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/stories_read_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/close_stories_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/writers_section.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:bookie/shared/data/writers.dart';

class HomeFirstScreen extends StatefulWidget {
  static const String name = 'first-screen';

  // TODO: aqui se traera la informacion desde las apis con clean architecture(dentro habra un caso de uso donde se implemntara el filtrado de historias por distancia)

  const HomeFirstScreen({super.key});

  @override
  State<HomeFirstScreen> createState() => _HomeFirstScreenState();
}

class _HomeFirstScreenState extends State<HomeFirstScreen> {
  final PageController _pageController = PageController();

  void _showSearchSection() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Página principal
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavBarCustom(
                  userName: "Luis",
                  avatarUrl:
                      "https://i.pinimg.com/736x/61/c9/a3/61c9a321f61a2650790911e828ada56d.jpg",
                  onSearchTapped: _showSearchSection, // Botón de búsqueda
                ),
                HeroSection(unreadStories: unreadStories),
                CloseStoriesSection(),
                StoriesReadSection(readStories: readStories),
                WritersSection(writers: writers),
              ],
            ),
          ),

          // Sección de búsqueda
          HomeFirstSearch(
            pageController: _pageController,
          ),
        ],
      ),
    );
  }
}

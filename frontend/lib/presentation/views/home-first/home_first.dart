import 'package:bookie/config/intl/get_location_for_intl.dart';
import 'package:bookie/config/intl/i18n.dart';
import 'package:bookie/presentation/providers/story_provider.dart';
import 'package:bookie/presentation/views/home-first/home_first_search.dart';
import 'package:flutter/material.dart';
import 'package:bookie/presentation/widgets/navbar/navbar_homepage.dart';
import 'package:bookie/presentation/widgets/section/home_first/hero_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/stories_read_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/close_stories_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/writers_section.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:bookie/shared/data/writers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFirstScreen extends ConsumerStatefulWidget {
  static const String name = 'first-screen';

  // TODO: aqui se traera la informacion desde las apis con clean architecture(dentro habra un caso de uso donde se implemntara el filtrado de historias por distancia)

  const HomeFirstScreen({super.key});

  @override
  ConsumerState<HomeFirstScreen> createState() => _HomeFirstScreenState();
}

class _HomeFirstScreenState extends ConsumerState<HomeFirstScreen> {
  final PageController _pageController = PageController();
  AppLocalizations? localizations; // Cambiar a nullable

  List<Map<String, dynamic>> allStories = [];
  List<Map<String, dynamic>> filteredStories = [];

  @override
  void initState() {
    super.initState();
    detectLanguage().then((locale) {
      changeLanguage(locale);
    });
    ref.read(getStoriesProvider.notifier).loadStories();
    allStories = [...readStories, ...unreadStories];
    filteredStories = allStories;
  }

  void changeLanguage(String locale) async {
    setState(() {
      localizations = AppLocalizations(locale);
      localizations?.load();
    });
  }

  void _showSearchSection() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(getStoriesProvider);

    if (stories.isEmpty) {
      // Mostrar un spinner o placeholder mientras no hay datos
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
                    localizations: localizations,
                    changeLanguage: changeLanguage),
                HeroSection(unreadStories: unreadStories),
                CloseStoriesSection(stories: stories),
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

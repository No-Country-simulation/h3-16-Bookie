import 'package:bookie/config/intl/get_location_for_intl.dart';
import 'package:bookie/config/intl/i18n.dart';
import 'package:bookie/presentation/providers/genres_provider.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
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
  bool isLoading = false;
  bool isMounted = true;

  List<Map<String, dynamic>> allStories = [];
  List<Map<String, dynamic>> filteredStories = [];

  @override
  void initState() {
    super.initState();
    detectLanguage().then((locale) {
      changeLanguage(locale);
    });
    ref.read(storiesAllProvider.notifier).loadAllStories();
    ref.read(getGenresProvider.notifier).loadGenres();
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

  Future<void> onRefresh() async {
    isLoading = true;
    setState(() {});

    // simular carga de datos
    await ref.read(storiesAllProvider.notifier).loadAllStories();

    if (!isMounted) return;
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isMounted = false;
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(storiesAllProvider);

    if (stories.isEmpty) {
      // Mostrar un spinner o placeholder mientras no hay datos
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: PageView(
        controller: _pageController,
        physics:
            NeverScrollableScrollPhysics(), // Desactiva el desplazamiento por gestos
        children: [
          // Página principal
          RefreshIndicator(
            onRefresh: onRefresh,
            edgeOffset: 10,
            strokeWidth: 2,
            child: SingleChildScrollView(
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
                  CloseStoriesSection(
                      stories: stories, localizations: localizations),
                  StoriesReadSection(readStories: readStories),
                  WritersSection(writers: writers),
                ],
              ),
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

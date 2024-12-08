import 'package:bookie/config/intl/get_location_for_intl.dart';
import 'package:bookie/config/intl/i18n.dart';
import 'package:bookie/presentation/providers/favorite_provider.dart';
import 'package:bookie/presentation/providers/genres_provider.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/providers/user_provider.dart';
import 'package:bookie/presentation/views/home-first/home_first_search.dart';
import 'package:flutter/material.dart';
import 'package:bookie/presentation/widgets/navbar/navbar_homepage.dart';
import 'package:bookie/presentation/widgets/section/home_first/hero_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/stories_read_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/close_stories_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/writers_section.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  @override
  void initState() {
    super.initState();
    detectLanguage().then((locale) {
      changeLanguage(locale);
    });
    ref.read(storiesAllProvider.notifier).loadAllStories();
    ref.read(getGenresProvider.notifier).loadGenres();
    ref.read(usersProvider.notifier).loadWriters();
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
    await ref.read(usersProvider.notifier).reloadWriters();

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
    final writers = ref.watch(usersProvider);

    final colors = Theme.of(context).colorScheme;

    if (stories.isEmpty || writers.isEmpty) {
      return Center(
        child: SpinKitFadingCircle(
          color: colors.primary,
          size: 50.0,
        ),
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

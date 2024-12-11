import 'package:bookie/presentation/providers/genres_provider.dart';
import 'package:bookie/presentation/providers/read_provider.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/providers/user_provider.dart';
import 'package:bookie/presentation/views/home-first/home_first_search.dart';
import 'package:bookie/presentation/widgets/shared/shimmer_close_card.dart';
import 'package:bookie/presentation/widgets/shared/shimmer_writter_card.dart';
import 'package:flutter/material.dart';
import 'package:bookie/presentation/widgets/navbar/navbar_homepage.dart';
import 'package:bookie/presentation/widgets/section/home_first/hero_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/stories_read_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/close_stories_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/writers_section.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFirstScreen extends ConsumerStatefulWidget {
  static const String name = 'first-screen';

  const HomeFirstScreen({super.key});

  @override
  ConsumerState<HomeFirstScreen> createState() => _HomeFirstScreenState();
}

class _HomeFirstScreenState extends ConsumerState<HomeFirstScreen> {
  final PageController _pageController = PageController();
  // AppLocalizations? localizations; // Cambiar a nullable
  bool isLoading = false;
  bool isMounted = true;

  @override
  void initState() {
    super.initState();
    // detectLanguage().then((locale) {
    //   changeLanguage(locale);
    // });
    ref.read(storiesAllProvider.notifier).loadAllStories();
    ref.read(getGenresProvider.notifier).loadGenres();
    ref.read(usersProvider.notifier).loadWriters();
    ref.read(readProvider.notifier).getReaders();
  }

  // void changeLanguage(String locale) async {
  //   setState(() {
  //     localizations = AppLocalizations(locale);
  //     localizations?.load();
  //   });
  // }

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
    await ref.read(readProvider.notifier).getReaders();

    if (!isMounted) return;
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    isMounted = false;
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(storiesAllProvider);
    final writers = ref.watch(usersProvider);
    final readers = ref.watch(readProvider);

    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    final colors = Theme.of(context).colorScheme;

    // if (stories.isEmpty || writers.isEmpty) {
    //   return Center(
    //     child: SpinKitFadingCircle(
    //       color: colors.primary,
    //       size: 50.0,
    //     ),
    //   );
    // }

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
                    // localizations: localizations,
                    // changeLanguage: changeLanguage
                  ),
                  HeroSection(unreadStories: heroSectionTemporal),
                  stories.isEmpty
                      ? ShimmerCardContent()
                      : CloseStoriesSection(
                          stories: stories,
                          // localizations: localizations
                        ),
                  readers.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 16.0, right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Cambié a start para alinearlo a la izquierda
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Historias leidas",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    "Ingresa a cualquier historia, necesitas estar cerca para empezar a leer.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkmode
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : StoriesReadSection(readStories: readers),
                  writers.isEmpty
                      ? ShimmerWidgetWritterCard()
                      : WritersSection(writers: writers),
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

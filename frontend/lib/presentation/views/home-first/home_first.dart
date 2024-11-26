import 'package:bookie/presentation/providers/story_provider.dart';
import 'package:flutter/material.dart';
import 'package:bookie/presentation/widgets/navbar/navbar_homepage.dart';
import 'package:bookie/presentation/widgets/section/home_first/hero_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/stories_read_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/close_stories_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/writers_section.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:bookie/shared/data/writers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeFirstScreen extends ConsumerStatefulWidget {
  static const String name = 'first-screen';

  const HomeFirstScreen({super.key});

  @override
  ConsumerState<HomeFirstScreen> createState() => _HomeFirstScreenState();
}

class _HomeFirstScreenState extends ConsumerState<HomeFirstScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allStories = [];
  List<Map<String, dynamic>> filteredStories = [];

  @override
  void initState() {
    super.initState();
    ref.read(getStoriesProvider.notifier).loadStories();
    allStories = [...readStories, ...unreadStories];
    filteredStories = allStories;
  }

  void _onSearch(String query) {
    setState(() {
      filteredStories = allStories
          .where((story) =>
              story['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showSearchSection() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _hideSearchSection() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    _searchController.clear();
    _onSearch('');
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
                ),
                HeroSection(unreadStories: unreadStories),
                CloseStoriesSection(stories: stories),
                StoriesReadSection(readStories: readStories),
                WritersSection(writers: writers),
              ],
            ),
          ),

          // Sección de búsqueda
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _hideSearchSection,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Buscar historias...',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: _onSearch,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStories.length,
                  itemBuilder: (context, index) {
                    final story = filteredStories[index];
                    return ListTile(
                      leading: Image.network(
                        story['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(story['title']),
                      subtitle: Text(
                          story.containsKey('chapter') ? story['chapter'] : ''),
                      onTap: () {
                        // Acción al seleccionar una historia
                        print("Seleccionaste: ${story['title']}");
                        context.go('/history/${story['id']}');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

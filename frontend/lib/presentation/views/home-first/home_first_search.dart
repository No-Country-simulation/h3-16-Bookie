import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/config/helpers/word_plural.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/mappers/genredb_mapper.dart';
import 'package:bookie/presentation/providers/genres_provider.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeFirstSearch extends ConsumerStatefulWidget {
  final PageController pageController;
  const HomeFirstSearch({super.key, required this.pageController});

  @override
  ConsumerState<HomeFirstSearch> createState() => _HomeFirstSearchState();
}

class _HomeFirstSearchState extends ConsumerState<HomeFirstSearch> {
  final TextEditingController _searchController = TextEditingController();

  List<Story> allStories = [];
  List<Story> filteredStories = [];

  @override
  void initState() {
    super.initState();
    // Combinar historias leídas y no leídas
    allStories = ref.read(storiesAllProvider);
    filteredStories = allStories;
  }

  void _onSearch(String query) {
    setState(() {
      filteredStories = allStories
          .where((story) =>
              story.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _hideSearchSection() {
    widget.pageController.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    _searchController.clear();
    _onSearch('');
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    final genres = ref.watch(getGenresProvider);
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Column(
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
                    hintText: 'Buscar por título de la historia...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onSearch,
                ),
              ),
            ],
          ),
        ),

        // Lista de géneros
        if (genres.isNotEmpty)
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: genres.map((genre) {
                  final genreName = GenreExtension(genre).displayName;

                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkmode ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 8.0,
                        ),
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        genreName,
                        style: TextStyle(
                          color: isDarkmode ? colors.primary : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        // Lista de historias
        Expanded(
          child: ListView.builder(
            itemCount: filteredStories.length,
            itemBuilder: (context, index) {
              final story = filteredStories[index];
              final imageMod = getImageUrl(isDarkmode, story.imageUrl);
              final genreStory = GenreExtension(story.genre).displayName;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: InkWell(
                  onTap: () {
                    context.push('/story-only/${story.id}');
                  },
                  splashColor: colors.primary.withAlpha(30),
                  highlightColor: colors.primary.withAlpha(50),
                  borderRadius: BorderRadius.circular(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2.0,
                    child: Container(
                      height: 100, // Altura compacta
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Imagen
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageMod,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          // Información de la historia
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  story.title,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${story.chapters.length} ${getChaptersLabel(story.chapters.length)}",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDarkmode
                                          ? colors.primary
                                          : colors.secondary,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      genreStory,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

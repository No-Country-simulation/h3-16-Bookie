import 'package:bookie/config/helpers/sorted.dart';
import 'package:bookie/presentation/widgets/shared/shimmer_loader.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:flutter/material.dart';
import 'package:bookie/presentation/widgets/cards/close_stories_card.dart';
import 'package:go_router/go_router.dart';

class CloseStoriesSection extends StatefulWidget {
  const CloseStoriesSection({super.key});

  @override
  State<CloseStoriesSection> createState() => _CloseStoriesSectionState();
}

class _CloseStoriesSectionState extends State<CloseStoriesSection> {
  late Future<List<Map<String, dynamic>>> sortedStoriesFuture;

// todo: esto cambiara no se hara de esta manera porque se traera de una api
  @override
  void initState() {
    super.initState();
    sortedStoriesFuture = getSortedStoriesFromGoogleMaps(
        unreadStories); // Aquí se ordenan las historias
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título "Historias cercanas"
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Historias cercanas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),

        // todo: esto cambiara, creo q no usar Future Builder sino como estaba antes no se hara de esta manera porque se traera de una api
        // Sección de "Más historias" con Scroll Horizontal
        FutureBuilder<List<Map<String, dynamic>>>(
          future: sortedStoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerLoader();
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final sortedStories = snapshot.data ?? [];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: List.generate(
                  sortedStories.length, // aqui usara la unredStories.length
                  (index) {
                    final story = sortedStories[
                        index]; // aqui usara la sortedStories[index]
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: SizedBox(
                        width: 150,
                        child: CloseStoriesCard(
                          id: story['id']!,
                          imageUrl: story['imageUrl']!,
                          title: story['title']!,
                          synopsis: story['synopsis']!,
                          rating: story['rating'],
                          reads: story['reads'],
                          distance: story['distance']!,
                          isFavorite: story['isFavorite'],
                          onCardPress: () {
                            context.go('/history/${story['id']}');
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

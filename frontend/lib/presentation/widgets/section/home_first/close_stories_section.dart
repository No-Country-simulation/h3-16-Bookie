import 'package:bookie/config/intl/i18n.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/providers/favorite_provider.dart';
import 'package:bookie/presentation/widgets/cards/close_stories_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CloseStoriesSection extends ConsumerStatefulWidget {
  final List<Story> stories;
  final AppLocalizations? localizations;

  const CloseStoriesSection(
      {super.key, required this.stories, this.localizations});

  @override
  ConsumerState<CloseStoriesSection> createState() =>
      _CloseStoriesSectionState();
}

class _CloseStoriesSectionState extends ConsumerState<CloseStoriesSection> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteProvider.notifier).getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteProvider);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Historias cercanas"
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Historias cercanas",
              // widget.localizations?.translate("homepage_close_stories") != null
              //     ? "${widget.localizations?.translate("homepage_close_stories")}"
              //     : "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colors.primary,
              ),
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: List.generate(
                widget.stories.length,
                (index) {
                  final story = widget.stories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: SizedBox(
                      width: 150, // Ajusta el tamaño del card
                      child: CloseStoriesCard(
                        id: story.id,
                        imageUrl: story.imageUrl,
                        title: story.title,
                        distance: story.distance,
                        onCardPress: () {
                          context.push('/story/${story.id}');
                        },
                        isFavorite: favorites
                            .any((element) => element.story.id == story.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

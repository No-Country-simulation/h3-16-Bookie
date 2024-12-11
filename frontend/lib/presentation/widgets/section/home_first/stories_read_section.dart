import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/domain/entities/read_entity.dart';
import 'package:bookie/presentation/widgets/cards/stories_read_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoriesReadSection extends StatelessWidget {
  final List<Read> readStories;

  const StoriesReadSection({super.key, required this.readStories});

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Cambié a start para alinearlo a la izquierda
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: List.generate(
                readStories.length,
                (index) {
                  final readStory = readStories[index];

                  final lastCompleteChapter = readStory.readChapters.lastWhere(
                    (chapter) => chapter.completeChapter,
                    orElse: () {
                      return ReadChapterComplete(
                          readChapter: ReadChapter(
                            id: 0,
                            title: '',
                            image: getImageUrl(isDarkmode, "sin-imagen"),
                          ),
                          completeChapter: false);
                    },
                  );

                  // final indexLastCompleteChapter = readStory.story.chapters
                  //     .indexOf(lastCompleteChapter.readChapter);

                  final indexLastCompleteChapter =
                      readStory.story.chapters.indexWhere(
                    (chapter) =>
                        chapter.id == lastCompleteChapter.readChapter.id,
                  );

                  if (!lastCompleteChapter.completeChapter) {
                    return Center(
                      child: Text(
                        "",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkmode ? Colors.grey : Colors.black,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    // Ajusta el espacio entre cards
                    child: SizedBox(
                      width: 120, // Reduce el ancho del card
                      child: StoriesReadCard(
                        imageUrl: getImageUrl(
                            isDarkmode,
                            lastCompleteChapter.readChapter.image ??
                                "sin-imagen"),
                        title: lastCompleteChapter.readChapter.title,
                        indexChapter: indexLastCompleteChapter,
                        onCardPress: () {
                          context.push('/story/${readStory.story.id}');
                        },
                        isCompleteStory: readStory.story.completeStory,
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

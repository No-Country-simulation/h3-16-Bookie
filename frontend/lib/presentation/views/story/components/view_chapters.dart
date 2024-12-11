import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:bookie/presentation/widgets/cards/story/chapter_card.dart';
import 'package:flutter/material.dart';

class StoryChapters extends StatefulWidget {
  final List<ChapterPartial> chapters;
  final int storyId;

  const StoryChapters(
      {super.key, required this.chapters, required this.storyId});

  @override
  State<StoryChapters> createState() => _StoryChaptersState();
}

class _StoryChaptersState extends State<StoryChapters> {
  late Future<bool> isUnlockedFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Capítulos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
        ]),
        const SizedBox(height: 8),
        Text(
          "Para desbloquear los capítulos, debes estar cerca.",
        ),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: widget.chapters.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final chapter = widget.chapters[index];

            return ChapterCard(
              index: index,
              chapterId: chapter.id,
              latitude: chapter.latitude,
              longitude: chapter.longitude,
              title: chapter.title,
              imageUrl: getImageUrl(isDarkmode, chapter.image ?? "sin-imagen"),
              storyId: widget.storyId,
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

import 'package:bookie/presentation/views/chapter/chapter_sucess_complete_story_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChaptersViewStoryWithPage extends StatelessWidget {
  final String pageContent;
  final TextStyle textStyle;
  final int? isCurrentChapter;
  final bool? isEndOfStory;
  final bool? isFirstPage;
  final int? chapterIndex;
  final String? titleChapter;

  const ChaptersViewStoryWithPage({
    super.key,
    required this.pageContent,
    required this.textStyle,
    this.isCurrentChapter,
    this.isEndOfStory,
    this.isFirstPage,
    this.chapterIndex,
    this.titleChapter,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      // bottom: false,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        isFirstPage != null && isFirstPage == true
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 120,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://picsum.photos/id/10/200/300"),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Column(children: [
                            Text(
                              titleChapter!,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDarkmode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              "Capítulo ${chapterIndex! + 1}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDarkmode
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        pageContent,
                        style: textStyle,
                      )
                    ]))
            : isEndOfStory == true
                ? ChapterSuccessCompleteStoryView(
                    pageContent: "Fin de la historia")
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    child: Text(
                      pageContent,
                      style: textStyle,
                    ),
                  ),
        if (isCurrentChapter != null &&
            isEndOfStory == false &&
            isCurrentChapter! > 0)
          ElevatedButton(
            onPressed: () {
              // Acción para ir al capítulo anterior
              context.push('/chapters/view/128/${isCurrentChapter! - 1}');
            },
            child: Text('Ir al capítulo ${isCurrentChapter!}'),
          ),
        if (isCurrentChapter != null && isEndOfStory == false)
          ElevatedButton(
            onPressed: () {
              // Acción para ir al siguiente capítulo
              context.push('/chapters/view/128/${isCurrentChapter! + 1}');
            },
            child: Text('Ir al capítulo ${isCurrentChapter! + 2}'),
          ),
      ]),
    );
  }
}

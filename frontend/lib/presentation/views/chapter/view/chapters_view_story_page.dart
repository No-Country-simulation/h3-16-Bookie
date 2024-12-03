import 'package:bookie/presentation/views/chapter/view/chapter_sucess_complete_chapter_view.dart';
import 'package:bookie/presentation/views/chapter/view/chapter_sucess_complete_story_view.dart';
import 'package:flutter/material.dart';

class ChaptersViewStoryWithPage extends StatelessWidget {
  final String pageContent;
  final TextStyle textStyle;
  final int? isCurrentChapter;
  final bool? isEndOfStory;
  final bool? isFirstPage;
  final int? chapterIndex;
  final String titleChapter;
  final double latitude;
  final double longitude;
  final int? randomNumber;
  final int currentChapter;
  final int storyId;

  const ChaptersViewStoryWithPage({
    super.key,
    required this.pageContent,
    required this.textStyle,
    required this.longitude,
    required this.latitude,
    required this.currentChapter,
    required this.titleChapter,
    this.isCurrentChapter,
    this.isEndOfStory,
    this.isFirstPage,
    this.chapterIndex,
    this.randomNumber,
    required this.storyId,
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
                              titleChapter,
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
                : (isCurrentChapter != null && isEndOfStory == false)
                    ? ChapterSuccessCompleteChapterView(
                        pageContent: pageContent,
                        isCurrentChapter: isCurrentChapter!,
                        latitude: latitude,
                        longitude: longitude,
                        randomNumber: randomNumber!,
                        currentChapter: currentChapter,
                        title: titleChapter,
                        storyId: storyId,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Text(
                          pageContent,
                          style: textStyle,
                        ),
                      ),
      ]),
    );
  }
}

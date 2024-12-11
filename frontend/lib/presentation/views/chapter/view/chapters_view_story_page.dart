import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/presentation/views/chapter/view/chapter_sucess_complete_chapter_view.dart';
import 'package:bookie/presentation/views/chapter/view/chapter_sucess_complete_story_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChaptersViewStoryWithPage extends ConsumerStatefulWidget {
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
  final String imageUrl;
  final int chapterId;

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
    required this.imageUrl,
    required this.chapterId,
  });

  @override
  ConsumerState<ChaptersViewStoryWithPage> createState() =>
      _ChaptersViewStoryWithPageState();
}

class _ChaptersViewStoryWithPageState
    extends ConsumerState<ChaptersViewStoryWithPage> {
  @override
  void initState() {
    super.initState();
    // Resetear el contenido traducido al entrar a esta página
    // Usar addPostFrameCallback para esperar a que la construcción inicial termine
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        widget.isFirstPage != null && widget.isFirstPage == true
            ? Stack(children: [
                Padding(
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
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  image: DecorationImage(
                                    image: NetworkImage(getImageUrl(
                                        isDarkmode, widget.imageUrl)),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.titleChapter,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkmode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Capítulo ${widget.chapterIndex! + 1}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDarkmode
                                            ? Colors.white.withOpacity(0.5)
                                            : Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            widget.pageContent,
                            style: widget.textStyle,
                          ),
                          // const SizedBox(height: 8),
                          // IconButton(
                          //     onPressed: () async {
                          //       await ref
                          //           .read(pageContentProvider.notifier)
                          //           .translateContent(widget.pageContent, "en");
                          //     },
                          //     color: colors.primary,
                          //     style: IconButton.styleFrom(
                          //       padding: const EdgeInsets.all(10),
                          //       shape: const RoundedRectangleBorder(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(10)),
                          //       ),
                          //       backgroundColor:
                          //           isDarkmode ? Colors.black : Colors.white,
                          //     ),
                          //     icon: const Icon(Icons.translate)),
                        ])),
              ])
            : widget.isEndOfStory == true
                ? ChapterSuccessCompleteStoryView(
                    pageContent: "Fin de la historia")
                : (widget.isCurrentChapter != null &&
                        widget.isEndOfStory == false)
                    ? ChapterSuccessCompleteChapterView(
                        pageContent: widget.pageContent,
                        isCurrentChapter: widget.isCurrentChapter!,
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                        randomNumber: widget.randomNumber!,
                        currentChapter: widget.currentChapter,
                        title: widget.titleChapter,
                        storyId: widget.storyId,
                        chapterId: widget.chapterId,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Text(
                          widget.pageContent,
                          style: widget.textStyle,
                        ),
                      ),
      ]),
    );
  }
}

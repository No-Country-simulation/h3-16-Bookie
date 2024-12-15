import 'package:animate_do/animate_do.dart';
import 'package:bookie/config/helpers/capitalize.dart';
import 'package:bookie/config/helpers/get_distance_minime.dart';
import 'package:bookie/config/helpers/word_plural.dart';
import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/infrastructure/mappers/genredb_mapper.dart';
import 'package:bookie/presentation/providers/favorite_provider.dart';
import 'package:bookie/presentation/providers/read_provider.dart';
import 'package:bookie/presentation/widgets/shared/image_3d.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class StoryHeroImageAndGeneral extends ConsumerStatefulWidget {
  final int storyId;
  final String imageUrl;
  final String title;
  final int lenChapters;
  final String nameWriter;
  final double latitudeStory;
  final double longitudeStory;
  final Genre genre;

  const StoryHeroImageAndGeneral({
    super.key,
    required this.storyId,
    required this.imageUrl,
    required this.title,
    required this.lenChapters,
    required this.nameWriter,
    required this.latitudeStory,
    required this.longitudeStory,
    required this.genre,
  });

  @override
  ConsumerState<StoryHeroImageAndGeneral> createState() =>
      _StoryHeroImageAndGeneralState();
}

class _StoryHeroImageAndGeneralState
    extends ConsumerState<StoryHeroImageAndGeneral>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late PageController _pageController;
  double _opacity = 0.0;

  Future<String> getLocation() async {
    return await getCountryAndProvinceAndDistance(
      widget.latitudeStory,
      widget.longitudeStory,
    );
  }

  @override
  void initState() {
    super.initState();
    ref.read(favoriteProvider.notifier).getFavorites();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    _rotationAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        // Comprobamos si el widget está montado
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = ref.watch(favoriteProvider);
    final isFavoriteStory =
        isFavorite.any((element) => element.story.id == widget.storyId);
    final shimmerBaseColor = isDarkmode ? Colors.grey[900]! : Colors.grey[300]!;
    final shimmerHighlightColor =
        isDarkmode ? Colors.grey[800]! : Colors.grey[100]!;
    final containerShimmer = isDarkmode ? Colors.black : Colors.white;
    final genreStory = GenreExtension(widget.genre).displayName;
    final readers = ref.watch(readProvider);
    final isComplete = readers.any((element) =>
        element.story.id == widget.storyId && element.story.completeStory);

    return Center(
      child: Column(children: [
        Stack(children: [
          My3DImage(imageUrl: widget.imageUrl, storyId: widget.storyId),
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                if (isFavoriteStory) {
                  ref
                      .read(favoriteProvider.notifier)
                      .removeFavorite(widget.storyId);
                } else {
                  ref
                      .read(favoriteProvider.notifier)
                      .addFavorite(widget.storyId);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isFavoriteStory ? Icons.favorite : Icons.favorite_border,
                  color: isFavoriteStory ? Colors.red : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // si el usuario leyó la historia, mostrar completado
          if (isComplete)
            Positioned(
              top: 16,
              left: 16,
              child: FadeIn(
                delay: const Duration(milliseconds: 2000),
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius:
                        BorderRadius.circular(12), // Bordes redondeados
                    // border: Border.all(
                    //   color: Colors.green, // Color del borde
                    // ),
                  ),
                  child: Text(
                    "Completado",
                    style: TextStyle(
                      color: Colors.green, // Color del texto
                      fontSize: 10,
                      fontWeight: FontWeight.bold, // Estilo destacado
                    ),
                  ),
                ),
              ),
            ),

          // genre
          Positioned(
            bottom: 20,
            right: 12,
            child: FadeIn(
              delay: const Duration(milliseconds: 2000),
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: Text(
                  genreStory,
                  style: TextStyle(
                    color: isDarkmode ? colors.primary : Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        ]),
        SizedBox(height: 8),
        AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeIn,
          child: Column(
            children: [
              Text(
                capitalizeFirstWord(widget.title),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(widget.nameWriter),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FutureBuilder(
              future: getLocation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(snapshot.data ?? "10 m",
                          style: TextStyle(
                              fontSize: 14,
                              color:
                                  isDarkmode ? Colors.grey : Colors.grey[700])),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 150,
                            height: 20,
                            color: containerShimmer,
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
            ),
            Row(
              children: [
                const Icon(Icons.book, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                    "${widget.lenChapters} ${getChaptersLabel(widget.lenChapters)}",
                    style: TextStyle(
                        fontSize: 14,
                        color: isDarkmode ? Colors.grey : Colors.grey[700])),
              ],
            ),
            // Row(
            //   children: [
            //     const Icon(Icons.access_time, size: 18, color: Colors.grey),
            //     const SizedBox(width: 4),
            //     const Text("30 min",
            //         style: TextStyle(fontSize: 14, color: Colors.grey)),
            //   ],
            // ),
          ],
        ),
      ]),
    );
  }
}

import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/config/helpers/word_plural.dart';
import 'package:bookie/presentation/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteCard extends ConsumerStatefulWidget {
  final int id;
  final String imageUrl;
  final String title;
  final int quantityChapters;
  final VoidCallback onCardPress;
  final bool isFavorite;

  const FavoriteCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.quantityChapters,
    required this.onCardPress,
    required this.isFavorite,
  });

  @override
  ConsumerState<FavoriteCard> createState() => _CloseStoriesCardState();
}

class _CloseStoriesCardState extends ConsumerState<FavoriteCard> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final imageMod = getImageUrl(true, widget.imageUrl);
    final image = NetworkImage(imageMod);
    image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onError: (exception, stackTrace) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // muchos repites este codigo revisar como factorizarlo mas adelante
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final shimmerBaseColor = isDarkmode ? Colors.grey[900]! : Colors.grey[300]!;
    final shimmerHighlightColor =
        isDarkmode ? Colors.grey[800]! : Colors.grey[100]!;
    final containerShimmer = isDarkmode ? Colors.black : Colors.white;

    final colors = Theme.of(context).colorScheme;
    final imageMod = getImageUrl(isDarkmode, widget.imageUrl);
    // final isFavorite = ref.watch(favoriteProvider);
    // final isFavoriteStory =
    //     isFavorite.any((element) => element.story.id == widget.id);

    return GestureDetector(
      onTap: widget.onCardPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                isLoading
                    ? Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            color: containerShimmer,
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: NetworkImage(imageMod),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                // Botón de favorito
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      // Llamar al Riverpod para alternar el estado del favorito usando el id
                      if (widget.isFavorite) {
                        ref
                            .read(favoriteProvider.notifier)
                            .removeFavorite(widget.id);
                      } else {
                        ref
                            .read(favoriteProvider.notifier)
                            .addFavorite(widget.id);
                      }
                    },
                  ),
                ),
              ],
            ),

            // Título
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0),
              child: isLoading
                  ? Shimmer.fromColors(
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title.length >= 12
                              ? widget.title.substring(0, 10)
                              : widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
            ),

            //rating - reads - distance
            Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, right: 8.0, left: 8.0, bottom: 8.0),
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 200,
                          height: 14,
                          color: containerShimmer,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.quantityChapters} ${getChaptersLabel(widget.quantityChapters)}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
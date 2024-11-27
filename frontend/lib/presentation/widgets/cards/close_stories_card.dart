// import 'package:bookie/presentation/providers/favorites_provider.dart';
import 'package:bookie/presentation/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class CloseStoriesCard extends ConsumerStatefulWidget {
  final int id; // ID único
  final String imageUrl; // URL de la imagen
  final String title;
  final String? synopsis;
  // final double? rating;
  // final int? reads;
  final int distance;
  final bool isFavorite;
  final VoidCallback onCardPress;

  const CloseStoriesCard({
    super.key,
    required this.id, // Requiere un id único
    required this.imageUrl,
    required this.title,
    this.synopsis,
    // this.rating,
    // this.reads,
    required this.distance,
    required this.isFavorite,
    required this.onCardPress,
  });

  @override
  ConsumerState<CloseStoriesCard> createState() => _CloseStoriesCardState();
}

class _CloseStoriesCardState extends ConsumerState<CloseStoriesCard> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final image = NetworkImage(widget.imageUrl);
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
    final isFavorite =
        ref.watch(favoriteProvider)[widget.id] ?? widget.isFavorite;

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
                            image: NetworkImage(widget.imageUrl),
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
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      // Llamar al Riverpod para alternar el estado del favorito usando el id
                      ref
                          .read(favoriteProvider.notifier)
                          .toggleFavorite(widget.id);
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
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
            ),

            // synopsis
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: isLoading
            //       ? Shimmer.fromColors(
            //           baseColor: Colors.grey[300]!,
            //           highlightColor: Colors.grey[100]!,
            //           child: Container(
            //             width: 150,
            //             height: 14,
            //             color: Colors.white,
            //           ),
            //         )
            //       : Text(
            //           widget.synopsis ?? '',
            //           style: TextStyle(fontSize: 14, color: Colors.grey),
            //           maxLines: 2,
            //           overflow: TextOverflow.ellipsis,
            //         ),
            // ),

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
                        // if (widget.rating != null)
                        //   Row(
                        //     children: [
                        //       Icon(Icons.star, color: Colors.amber, size: 16),
                        //       Text('${widget.rating}'),
                        //     ],
                        //   ),
                        // if (widget.rating != null)
                        //   Text(
                        //       '${HumanFormats.humanReadbleNumber(widget.reads ?? 0)} reads'),
                        Text(
                          "A ${widget.distance <= 500 ? "${widget.distance}m" : "${(widget.distance / 1000).toStringAsFixed(1)}km"}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
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

import 'package:bookie/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class HeroCard extends ConsumerStatefulWidget {
  final String id; // ID único
  final String imageUrl;
  final String title;
  final String? synopsis;
  final double? rating;
  final int? reads;
  final String? distance;
  final bool isFavorite;
  final VoidCallback onCardPress;

  const HeroCard({
    super.key,
    required this.id, // Requiere un id único
    required this.imageUrl,
    required this.title,
    this.synopsis,
    this.rating,
    this.reads,
    this.distance,
    required this.isFavorite,
    required this.onCardPress,
  });

  @override
  ConsumerState<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends ConsumerState<HeroCard> {
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
    // final colors = Theme.of(context).colorScheme;
    final isDarkmode = ref.watch(isDarkmodeProvider);
    final shimmerBaseColor = isDarkmode ? Colors.grey[900]! : Colors.grey[300]!;
    final shimmerHighlightColor =
        isDarkmode ? Colors.grey[800]! : Colors.grey[100]!;
    final containerShimmer = isDarkmode ? Colors.black : Colors.white;

    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //titulo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                : Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),

          ///subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 150,
                        height: 14,
                        color: containerShimmer,
                      ),
                    ),
                  )
                : Text(
                    widget.synopsis ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),

          // image
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Stack(
              children: [
                // hero image
                isLoading
                    ? Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            color: containerShimmer,
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

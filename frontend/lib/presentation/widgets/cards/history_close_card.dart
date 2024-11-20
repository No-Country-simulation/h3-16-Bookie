import 'package:bookie/config/helpers/human_formats.dart';
import 'package:bookie/presentation/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class HistoryCloseCard extends ConsumerStatefulWidget {
  final String id; // ID único
  final String imageUrl;
  final String title;
  final String? synopsis;
  final double? rating;
  final int? reads;
  final String? distance;
  final bool isFavorite;
  final VoidCallback onCardPress;

  const HistoryCloseCard({
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
  ConsumerState<HistoryCloseCard> createState() => _UnreadCardState();
}

class _UnreadCardState extends ConsumerState<HistoryCloseCard> {
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
    final colors = Theme.of(context).colorScheme;
    final isFavorite =
        ref.watch(favoriteProvider)[widget.id] ?? widget.isFavorite;

    return InkWell(
      onTap: widget.onCardPress,
      splashColor: colors.primary.withOpacity(0.3),
      highlightColor: colors.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 150,
                        height: 20,
                        color: Colors.white,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 150,
                        height: 14,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.synopsis ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 200,
                        height: 14,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.rating != null)
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text('${widget.rating}'),
                            ],
                          ),
                        if (widget.rating != null)
                          Text(
                              '${HumanFormats.humanReadbleNumber(widget.reads ?? 0)} reads'),
                        Text(widget.distance ?? ''),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

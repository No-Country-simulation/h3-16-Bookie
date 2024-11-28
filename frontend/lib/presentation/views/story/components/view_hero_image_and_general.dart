
import 'package:bookie/config/helpers/capitalize.dart';
import 'package:bookie/presentation/providers/favorites_provider.dart';
import 'package:bookie/presentation/widgets/shared/image_3d.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryHeroImageAndGeneral extends ConsumerStatefulWidget {
  final int storyId;
  final String imageUrl;
  final String title;
  final int lenChapters;
  final bool isFavorite;

  const StoryHeroImageAndGeneral({
    super.key,
    required this.isFavorite,
    required this.storyId,
    required this.imageUrl,
    required this.title,
    required this.lenChapters,
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    _rotationAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isFavorite =
        ref.watch(favoriteProvider)[widget.storyId] ?? widget.isFavorite;

    return Center(
      child: Column(children: [
        Stack(children: [
          My3DImage(
              imageUrl: widget.imageUrl,
              title: widget.title,
              storyId: widget.storyId),
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                ref
                    .read(favoriteProvider.notifier)
                    .toggleFavorite(widget.storyId);
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
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 24,
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
                capitalize(widget.title),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.primary),
              ),
              SizedBox(height: 8),
              Text("Autor: Ana Sofia"),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Bogota, a 2 km",
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.book, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${widget.lenChapters} capítulos",
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                const Text("30 min",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}

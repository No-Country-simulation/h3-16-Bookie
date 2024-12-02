import 'package:bookie/presentation/views/map/chapter/map_chapter_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MapChapter extends StatelessWidget {
  static const String name = 'chapter-map';

  const MapChapter({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? extra =
        GoRouterState.of(context).extra as Map<String, dynamic>?;

    final double latitude = extra?['latitude'] ?? 0.0;
    final double longitude = extra?['longitude'] ?? 0.0;

    return Scaffold(
        appBar: AppBar(
          title: Text('Ubicación del Capítulo'),
        ),
        body: MapChapterView(latitude: latitude, longitude: longitude));
  }
}

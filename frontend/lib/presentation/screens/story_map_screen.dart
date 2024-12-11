import 'package:bookie/presentation/views/story/components/view_map.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoryMapScreen extends StatelessWidget {
  static const String name = 'story-map';

  const StoryMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? extra =
        GoRouterState.of(context).extra as Map<String, dynamic>?;

    final double latitude = extra?['latitude'] ?? 0.0;
    final double longitude = extra?['longitude'] ?? 0.0;

    return Scaffold(
        appBar: AppBar(
          title: Text('Recorrido de la historia'),
        ),
        body: StoryViewMap(latitude: latitude, longitude: longitude));
  }
}

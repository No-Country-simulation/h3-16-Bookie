import 'package:flutter/material.dart';

class ChaptersViewStory extends StatelessWidget {
  static const String name = 'chapters-view-story';
  final int storyId;

  const ChaptersViewStory({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historias'),
      ),
      body: Center(
        child: Text('Historias'),
      ),
    );
  }
}

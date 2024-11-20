import 'package:bookie/presentation/widgets/section/read_section.dart';
import 'package:bookie/presentation/widgets/section/unread_section.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  static const String name = 'feed';

  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historias cerca...'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UnreadSection(unreadStories: unreadStories),
            ReadSection(readStories: readStories),
          ],
        ),
      ),
    );
  }
}

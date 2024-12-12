import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/views/story/view_story_screen.dart';
import 'package:bookie/presentation/widgets/shared/show_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StoryOnlyScreen extends ConsumerWidget {
  static const String name = 'story-only';
  final int storyId;

  const StoryOnlyScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStory =
        ref.watch(storiesAllProvider.notifier).getStoryById(storyId);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Story>(
          future: asyncStory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: SpinKitFadingCircle(color: colors.primary));
            } else if (snapshot.hasError) {
              return ShowError(message: "No se encontraron historias.");
            } else {
              return ViewStoryScreen(
                story: snapshot.data!,
              );
            }
          },
        ),
      ),
    );
  }
}

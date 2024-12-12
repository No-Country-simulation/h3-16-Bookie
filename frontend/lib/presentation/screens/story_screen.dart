import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/views/story/view_story_screen.dart';
import 'package:bookie/presentation/widgets/shared/show_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StoryScreen extends ConsumerStatefulWidget {
  final int storyId; // Recibimos el id desde la ruta
  static const String name = 'history';

  const StoryScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  late PageController _pageController;
  // final _notifierScroll = ValueNotifier(0.0);

  // void listener() {
  //   _notifierScroll.value = _pageController.page!;
  // }

  @override
  void initState() {
    super.initState();
    // Configura el PageController con el índice inicial basado en storyId
    final stories = ref.read(storiesAllProvider); // Obtén las historias

    final initialIndex =
        stories.indexWhere((story) => story.id == widget.storyId);

    _pageController =
        PageController(initialPage: initialIndex >= 0 ? initialIndex : 0);
    // _pageController.addListener(listener);
  }

  @override
  void dispose() {
    // _pageController.removeListener(listener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(storiesAllProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller:
              _pageController, // Asegúrate de usar el PageController aquí
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];

            return Consumer(builder: (context, ref, child) {
              final asyncStory =
                  ref.watch(storiesAllProvider.notifier).getStoryById(story.id);

              return FutureBuilder<Story>(
                future: asyncStory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitFadingCircle(color: colors.primary));
                  } else if (snapshot.hasError) {
                    return ShowError(message: "No se encontraron historias.");
                  } else {
                    return ViewStoryScreen(
                      story: snapshot.data!,
                    );
                  }
                },
              );
            });
          },
          // ),
        ),
      ),
    );
  }
}

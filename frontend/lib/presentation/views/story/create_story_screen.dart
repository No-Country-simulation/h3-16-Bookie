import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:bookie/presentation/providers/stories_user_provider.dart';
import 'package:bookie/presentation/widgets/cards/story/story_card.dart';
import 'package:bookie/presentation/widgets/shared/show_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class CreateHistoryScreen extends ConsumerStatefulWidget {
  const CreateHistoryScreen({super.key});

  @override
  ConsumerState<CreateHistoryScreen> createState() =>
      _CreateHistoryScreenState();
}

class _CreateHistoryScreenState extends ConsumerState<CreateHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos las historias del usuario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storiesUserProvider.notifier).loadUserStories();
    });
  }

  void _onCreateNewStory() {
    // Resetear capítulos al iniciar una nueva historia
    ref.read(chapterProvider.notifier).resetChapters();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme; // Colores del tema
    final state = ref.watch(storiesUserProvider);

    if (state.isLoading) {
      return Center(
        child: SpinKitFadingCircle(
          color: colors.primary,
          size: 50.0,
        ),
      );
    }

    if (state.hasError) {
      return ShowError(
          message: "No se encontraron historias, intenta de nuevo");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Creación de historias",
          style: TextStyle(
            color: colors.primary,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Resetear estado de capítulos al iniciar una nueva historia
          _onCreateNewStory();
          // Navegar a la pantalla de creación de historias
          context.push('/story/create');
        },
        label: const Text("Crear historia"),
        icon: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: state.stories.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 140,
                      width: 200,
                      child: Lottie.asset('assets/lottie/view_stories.json'),
                    ),
                    const Text(
                      "No tienes historias, comienza a crear una!",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Continuar escribiendo",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.stories.length + 1,
                        itemBuilder: (context, index) {
                          if (index < state.stories.length) {
                            final story = state.stories[index];

                            return StoryCard(
                              imageUrl: story.imageUrl,
                              title: story.title,
                              synopsis: story.synopsis,
                              lenChapters: story.chapters.length,
                              storyId: story.id,
                            );
                          } else if (index == 3) {
                            // Mostrar la imagen al final de las historias
                            return Center(
                              child: SizedBox(
                                height: 120,
                                width: 200,
                                child: Lottie.asset(
                                    'assets/lottie/view_stories.json'),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
      ),
    );
  }
}

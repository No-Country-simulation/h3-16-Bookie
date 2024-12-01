import 'package:bookie/presentation/providers/story_provider.dart';
import 'package:bookie/presentation/widgets/cards/story/story_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    // Cargar historias del usuario
    ref.read(getStoriesByUserProvider(1));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final storiesAsync = ref.watch(getStoriesByUserProvider(1));

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
          // Navegar a la pantalla de creación de historias
          context.push('/story/create');
        },
        label: const Text("Crear historia"),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
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

            // Mostrar historias del usuario usando el FutureProvider
            Expanded(
              child: storiesAsync.when(
                data: (stories) {
                  return ListView.builder(
                    itemCount: stories.length + 1,
                    itemBuilder: (context, index) {
                      if (index < stories.length) {
                        final story = stories[index];

                        return GestureDetector(
                          onTap: () {
                            // Navegar a la vista de detalles de la historia
                            context.push('/story/edit/${story.id}');
                          },
                          child: StoryCard(
                            imageUrl: story.imageUrl,
                            title: story.title,
                            synopsis: story.synopsis,
                            lenChapters: story.chapters!.length,
                          ),
                        );
                      } else {
                        // Mostrar la imagen al final de las historias
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            Center(
                              child: Image.asset(
                                'assets/images/sapiens_story_create.png',
                                height: 200,
                                width: 200,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    "Error al cargar historias: $error",
                    style: TextStyle(color: colors.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/presentation/providers/story_provider.dart';
import 'package:bookie/presentation/views/story/components/view_chapters.dart';
import 'package:bookie/presentation/views/story/components/view_hero_image_and_general.dart';
import 'package:bookie/presentation/views/story/components/view_preview_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryScreen extends ConsumerStatefulWidget {
  final int storyId; // Recibimos el id desde la ruta
  static const String name = 'history';

  const StoryScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Configura el PageController con el índice inicial basado en storyId
    final stories = ref.read(getStoriesProvider); // Obtén las historias
    final initialIndex =
        stories.indexWhere((story) => story.id == widget.storyId);
    _pageController =
        PageController(initialPage: initialIndex >= 0 ? initialIndex : 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(getStoriesProvider);

    return Scaffold(
      // appBar: !_pageController.hasClients
      //     ? AppBar(
      //         title: Text('Historias'),
      //       )
      //     : null,
      body: SafeArea(
        child: PageView.builder(
          controller:
              _pageController, // Asegúrate de usar el PageController aquí
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];

            return Consumer(
              builder: (context, ref, child) {
                final asyncStory = ref.watch(getStoryByIdProvider(story.id));

                return asyncStory.when(
                  data: (story) => _StoryScreenDetail(
                    pageController: _pageController,
                    story: story,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text("Error cargando historia: $error"),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _StoryScreenDetail extends StatelessWidget {
  final PageController _pageController;
  final Story story;

  const _StoryScreenDetail({
    required PageController pageController,
    required this.story,
  }) : _pageController = pageController;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hero Image (25% de la pantalla)
          StoryHeroImageAndGeneral(
              storyId: story.id,
              isFavorite: story.isFavorite,
              imageUrl: story.imageUrl,
              title: story.title,
              lenChapters: story.chapters!.length),

          const SizedBox(height: 16),
          // Mapa y botón de Google Maps
          StoryPreviewMaps(
            latitude: story.chapters![0].latitude,
            longitude: story.chapters![0].longitude,
            storyId: story.id,
          ),

          const SizedBox(height: 16),
          // Sinopsis
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Sinopsis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  )),
              const SizedBox(height: 8),
              Text(
                'Esta es la sinopsis de la historia que tiene una narrativa emocionante sobre el viaje que vas a realizar. Prepárate para una gran aventura.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Lugares cercanos
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Alineación a la izquierda
            children: [
              Text(
                'Lugares',
                textAlign: TextAlign.center, // Título centrado
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primary, // Color destacado
                ),
              ),
              const SizedBox(height: 12),
              // Lista de lugares
              Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Alinea los lugares a la izquierda
                  children: [
                    Text(
                      '- Museo del Oro Bogotá Cra. 6 #15-88',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '- Address 2 chapter 2',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '- Address 3 chapter 3',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                  ]),
            ],
          ),

          const SizedBox(height: 16),
          // colocame como un separator que sea visible
          Divider(
            thickness: 1,
            color: Colors.grey.withOpacity(0.5),
            height: 1,
          ),
          const SizedBox(height: 16),

          // mostrando temporalmente los capitulos para hacer el mostrado o bloqueado de historias cuando el suusario esta cerca a la ubicación
          StoryChapters()
        ],
      ),
    ));
  }
}

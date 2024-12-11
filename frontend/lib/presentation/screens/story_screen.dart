import 'package:bookie/config/helpers/get_address.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/views/story/components/view_chapters.dart';
import 'package:bookie/presentation/views/story/components/view_hero_image_and_general.dart';
import 'package:bookie/presentation/views/story/components/view_preview_map.dart';
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
        child:
            PageView.builder(
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
                    return _StoryScreenDetail(
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

class _StoryScreenDetail extends ConsumerWidget {
  final Story story;
  const _StoryScreenDetail({
    required this.story,
  });

  Future<List<String>> getAddresses() async {
    return await getAddressesFromCoordinates(
      story.chapters
          .map((chapter) => [
                chapter.latitude,
                chapter.longitude,
              ])
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
      },
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Hero Image (25% de la pantalla)
            StoryHeroImageAndGeneral(
              storyId: story.id,
              imageUrl: story.imageUrl,
              title: story.title,
              lenChapters: story.chapters.length,
              nameWriter: story.writer?.name ?? "Autor desconocido",
              latitudeStory: story.chapters[0].latitude,
              longitudeStory: story.chapters[0].longitude,
              // rotation: rotation,
              // fixRotation: fixRotation,
            ),

            const SizedBox(height: 16),

            StoryPreviewMaps(
              latitude: story.chapters[0].latitude,
              longitude: story.chapters[0].longitude,
              storyId: story.id,
              chapters: story.chapters,
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
                  story.synopsis,
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
                      FutureBuilder(
                        future: getAddresses(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: SpinKitFadingCircle(
                                color: Colors.grey,
                                size: 20.0,
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Text(
                              snapshot.data?.join('\n') ??
                                  'Direccion no encontrada',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Text(
                              'Direccion no encontrada',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            );
                          }
                        },
                      ),
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
            StoryChapters(storyId: story.id, chapters: story.chapters),

            const SizedBox(height: 8),
          ],
        ),
      )),
    );
  }
}

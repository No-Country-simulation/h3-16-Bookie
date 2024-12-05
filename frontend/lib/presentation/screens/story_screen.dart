import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/views/story/components/view_chapters.dart';
import 'package:bookie/presentation/views/story/components/view_hero_image_and_general.dart';
import 'package:bookie/presentation/views/story/components/view_preview_map.dart';
import 'package:bookie/presentation/widgets/shared/show_error.dart';
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

    return Scaffold(
      body: SafeArea(
          child:
              // ValueListenableBuilder<double>(
              // valueListenable: _notifierScroll,
              // builder: (context, value, _) {
              // return
              PageView.builder(
        controller: _pageController, // Asegúrate de usar el PageController aquí
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          // final percentage = index - value;
          // final rotation = percentage.clamp(0.0, 1.0);
          // final fixRotation = pow(rotation, 0.35);

          return Consumer(
            builder: (context, ref, child) {
              final asyncStory = ref.watch(getStoryByIdProvider(story.id));

              return asyncStory.when(
                data: (story) => _StoryScreenDetail(
                  pageController: _pageController,
                  story: story,
                  // rotation: rotation,
                  // fixRotation: fixRotation,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    ShowError(message: "No se encontró la historia."),
              );
            },
          );
        },
      )
          // }
          // ),
          ),
    );
  }
}

class _StoryScreenDetail extends ConsumerWidget {
  final PageController _pageController;
  final Story story;
  // final double rotation;
  // final num fixRotation;

  const _StoryScreenDetail({
    required PageController pageController,
    // required this.rotation,
    // required this.fixRotation,
    required this.story,
  }) : _pageController = pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        // Obtener los capítulos usando el provider
        // TODO REVISAR PARA ACTULIAZAR INFO TALVEZ YA SE CREARON OTROS CAPITULOS Y TBM PARA REFRESCAR LA UBICACION
        // ref.read(storiesAllProvider.notifier).loadAllStories();
        // return true;
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
              isFavorite: false, // TODO FAVORITOS
              imageUrl: story.imageUrl,
              title: story.title,
              lenChapters: story.chapters.length,
              nameWriter: story.writer?.name ?? "Autor desconocido",
              // rotation: rotation,
              // fixRotation: fixRotation,
            ),

            const SizedBox(height: 16),
            // Mapa y botón de Google Maps
            // TODO: CREO QUE SI SE PUEDE COLOCAR LOS CAPÍTULOS EN EL MAPA, PROBAR
            // TODO: AQUI SE ROMPE CUANDO AÑADES CAPITULOS AL PROVIDER , TE FALTA ESA PARTE CUANDO SE AÑADEN CAPÍTULOS ADD CHAPTER EN LA STORY DEL ALL PROVIDER SINO SE ROMPE, O NOSE AVIRIGUAR BIEN ESTO
            StoryPreviewMaps(
              latitude: story.chapters[0].latitude,
              longitude: story.chapters[0].longitude,
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
                      // TODO ESTOS LUGARES LO PUEDES SACAR DELA API DE GOOGLE POR CAPITULOS AVER Q SALE
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
            StoryChapters(storyId: story.id, chapters: story.chapters)
          ],
        ),
      )),
    );
  }
}

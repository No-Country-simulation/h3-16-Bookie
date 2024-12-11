import 'package:bookie/config/helpers/get_bio_writer.dart';
import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/config/helpers/word_plural.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/providers/user_provider.dart';
import 'package:bookie/presentation/widgets/shared/show_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class WriterProfileScreen extends ConsumerStatefulWidget {
  final int writerId;
  static const String name = 'writer-profile';

  const WriterProfileScreen({super.key, required this.writerId});

  @override
  ConsumerState<WriterProfileScreen> createState() =>
      _WriterProfileScreenState();
}

class _WriterProfileScreenState extends ConsumerState<WriterProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos las historias del escritor usando el FutureProvider.
    ref.read(getStoriesByUserProvider(widget.writerId));
    ref.read(usersProvider.notifier).loadWriters();
  }

  @override
  Widget build(BuildContext context) {
    final bannerImageUrl =
        "https://picsum.photos/id/${widget.writerId}/200/300"; // Banner simulado

    // Aquí usamos el FutureProvider para obtener las historias.
    final storiesAsync = ref.watch(getStoriesByUserProvider(widget.writerId));
    final writers = ref.watch(usersProvider);

    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Escritor'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: writers.isEmpty
            ? Center(
                child: SpinKitFadingCircle(
                  color: colors.primary,
                  size: 50.0,
                ),
              )
            : storiesAsync.when(
                data: (stories) {
                  final writer =
                      writers.firstWhere((w) => w.id == widget.writerId);

                  // Si se cargaron las historias correctamente, mostramos la lista.
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Encabezado con banner e imagen del escritor
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Imagen de fondo (banner)
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(bannerImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Imagen del escritor
                            Positioned(
                              bottom: -50,
                              left: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: isDarkmode
                                    ? Colors.grey[800]
                                    : Colors.white,
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundImage: NetworkImage(writer
                                          .imageUrl ??
                                      "https://res.cloudinary.com/dlixnwuhi/image/upload/v1733600879/eiwptc2xepcddfjaavqo.webp"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 60), // Espacio para la imagen circular
                        // Nombre del escritor
                        Center(
                          child: Text(
                            writer.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Biografía breve
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            generarBioWriter(),
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkmode
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Historias del escritor
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Historias',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Aquí usamos el FutureProvider para mostrar el estado de las historias.
                        stories.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: stories.length,
                                itemBuilder: (context, index) {
                                  final story = stories[index];

                                  final imageMod =
                                      getImageUrl(isDarkmode, story.imageUrl);

                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          imageMod,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(story.title),
                                      subtitle: Text(
                                          '${story.chapters.length} ${getChaptersLabel(story.chapters.length)}'),
                                      onTap: () {
                                        // Acción para navegar a la historia
                                        context.push('/story/${story.id}');
                                      },
                                    ),
                                  );
                                },
                              )
                            : Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      bannerImageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text("El jinete de la historia"),
                                  subtitle: Text('1 capítulo'),
                                  onTap: () {
                                    // Acción para navegar a la historia
                                    context.push('/story/1');
                                  },
                                ),
                              ),
                      ],
                    ),
                  );
                },
                loading: () {
                  // Si las historias están cargando, mostramos un indicador de carga.
                  return Center(
                    child: SpinKitFadingCircle(
                      color: colors.primary,
                      size: 50.0,
                    ),
                  );
                },
                error: (error, stack) {
                  // Si ocurre un error, mostramos el mensaje de error.
                  return ShowError(
                    message: "No se encontró información sobre este escritor.",
                  );
                },
              ),
      ),
    );
  }
}

import 'package:bookie/config/helpers/capitalize.dart';
import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/infrastructure/mappers/genredb_mapper.dart';
import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/providers/stories_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class StoryEditDetailChaptersPage extends ConsumerStatefulWidget {
  static const String name = 'story-edit-detail-chapters';
  final int storyId;

  const StoryEditDetailChaptersPage({super.key, required this.storyId});

  @override
  ConsumerState<StoryEditDetailChaptersPage> createState() =>
      _StoryEditDetailChaptersPageState();
}

class _StoryEditDetailChaptersPageState
    extends ConsumerState<StoryEditDetailChaptersPage> {
  bool isLoading = true;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    // Cargar capítulos del historia por id
    ref.read(getStoryByIdProvider(widget.storyId));
    _loadChapters();
    // Cargar capítulos del historia por id
  }

  Future<void> _loadChapters() async {
    try {
      // Obtener los capítulos usando el provider
      await ref.read(chapterProvider.notifier).getChapters(widget.storyId);
    } catch (e) {
      // Manejo de errores
    } finally {
      setState(() {
        isLoading =
            false; // Establecer la carga en false cuando termine la solicitud
      });
    }
  }

  Future<void> _deleteStory() async {
    setState(() {
      isDeleting = true; // Mostrar el loader
    });

    ref
        .read(storiesUserProvider.notifier)
        .deleteStory(widget.storyId)
        .then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Historia eliminada",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al eliminar historia",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).whenComplete(() {
      setState(() {
        isDeleting = false; // Ocultar el loader
      });
      context.go("/home/2");
    });

    // } catch (e) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text("Error al eliminar historia",
    //         style: TextStyle(color: Colors.white)),
    //     backgroundColor: Colors.red,
    //   ),
    // );
    // } finally {
    // Navigator.of(context).pop();
    // context.push('/home/2');
    // }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false, // No se puede cerrar al hacer clic afuera
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta historia?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el modal sin eliminar
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteStory();
                // Navigator.of(context).pop(); // Cerrar el modal sin eliminar
              },
              child: Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyAsync = ref.watch(getStoryByIdProvider(widget.storyId));
    final chapters = ref.watch(chapterProvider);
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final colorGeneral = isDarkmode ? Colors.white : Colors.black;

    return Scaffold(
        appBar: AppBar(
          title: Text('Detalles de la Historia'),
          actions: [
            AbsorbPointer(
              absorbing: isDeleting,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'preview':
                      if (chapters.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "No hay capítulos disponibles, crea uno para verlo."),
                            backgroundColor: colors.primary,
                          ),
                        );
                        return;
                      }
                      context.push('/story-only/${widget.storyId}');
                      break;
                    // case 'share':
                    //   break;
                    case 'delete':
                      showDeleteConfirmationDialog(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'preview',
                      child: Text('Vista previa'),
                    ),
                    // PopupMenuItem(
                    //   value: 'share',
                    //   child: Text('Compartir'),
                    // ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  ];
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            storyAsync.when(
              data: (story) {
                final imageMod = getImageUrl(isDarkmode, story.imageUrl);

                return AbsorbPointer(
                  absorbing: isDeleting,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tarjeta de la historia
                          Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Row(
                              children: [
                                // Imagen de la historia
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(imageMod),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                // Título de la historia
                                Expanded(
                                  child: Text(
                                    story.title,
                                    style: TextStyle(
                                      color: colorGeneral,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          // Información de la historia
                          ListTile(
                            dense: true,
                            title: Text(
                              'Descripción',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Text(
                              story.synopsis,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Divider(color: Colors.grey, height: 1),
                          ListTile(
                            dense: true,
                            title: Text(
                              'Categoría',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Text(
                              GenreExtension(story.genre).displayName,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Divider(color: Colors.grey, height: 1),
                          ListTile(
                            dense: true,
                            title: Text(
                              'Ubicación',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Text(
                              capitalizeAllWords(
                                  '${story.country != "TEMPORAL" ? "${story.country}, " : ""}${story.province != "TEMPORAL" ? story.province : "Otro"}'),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Divider(color: Colors.grey, height: 1),

                          // Lista de capítulos
                          SizedBox(height: 16),

                          // Lista de capítulos
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Capítulos (${isLoading ? '0' : chapters.length})',
                                style: TextStyle(
                                  color: colorGeneral,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Acción al presionar el botón
                                  context.push(
                                    '/chapter/create/${widget.storyId}',
                                  );
                                },
                                borderRadius: BorderRadius.circular(
                                    8), // Opcional, para un efecto visual más elegante
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add, color: colorGeneral),
                                      SizedBox(
                                          width:
                                              8), // Separación entre el icono y el texto
                                      Text(
                                        'Añadir capítulo',
                                        style: TextStyle(color: colorGeneral),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 8),

                          // Lista de capítulos
                          isLoading
                              ? SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: SpinKitFadingCircle(
                                      color: colors.primary,
                                      size: 50.0,
                                    ),
                                  ),
                                ) // Muestra cargando
                              : chapters.isEmpty
                                  ? Center(
                                      child:
                                          Text("No hay capítulos disponibles"))
                                  : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: chapters.length,
                                      itemBuilder: (context, index) {
                                        final chapter = chapters[index];

                                        return Card(
                                          color: isDarkmode
                                              ? Colors.black
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.all(8.0),
                                            leading: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      getImageUrl(
                                                          isDarkmode,
                                                          chapter.image ??
                                                              "sin-imagen")),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              chapter.title,
                                              style: TextStyle(
                                                color: isDarkmode
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Capítulo ${index + 1}',
                                            ),
                                            onTap: () {
                                              context.push(
                                                  '/chapter/create/${widget.storyId}/edit/${chapter.id}',
                                                  extra: {
                                                    "title": chapter.title,
                                                    "content": chapter.content,
                                                    "image": chapter.image,
                                                    "edit": true,
                                                  });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                        ],
                      ),
                    ),
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
                return Center(
                  child: Text("Error cargando historias: $error"),
                );
              },
            ),
            if (isDeleting)
              ModalBarrier(
                color: Colors.black.withOpacity(0.5),
                dismissible: false,
              ),
            if (isDeleting)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitFadingCircle(
                      color: colors.primary,
                      size: 50.0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Borrando historia...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ));
  }
}

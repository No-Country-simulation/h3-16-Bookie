import 'dart:math';

import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:bookie/presentation/providers/translater_chapter.dart';
import 'package:bookie/presentation/views/chapter/view/chapters_view_story_page.dart';
import 'package:bookie/presentation/widgets/shared/message_empty_chapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_flip/page_flip.dart';

class ChaptersViewStory extends ConsumerStatefulWidget {
  static const String name = 'chapters-view-story';
  final int storyId;
  final int chapterIndex;

  const ChaptersViewStory(
      {super.key, required this.storyId, required this.chapterIndex});

  @override
  ConsumerState<ChaptersViewStory> createState() => _ChaptersViewStoryState();
}

class _ChaptersViewStoryState extends ConsumerState<ChaptersViewStory> {
  bool isLoading = true;
  final _controller = GlobalKey<PageFlipWidgetState>();
  List<String> pages = [];

  int initRandomNumber() {
    final randomNumber =
        Random().nextInt(4) + 1; // Genera un número entre 1 y 4
    return randomNumber;
  }

  Future<void> _loadChapters() async {
    setState(() {
      isLoading = true; // Mostrar indicador de carga
    });

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

  List<String> paginateContent(
      String content, TextStyle textStyle, Size screenSize) {
    final words = content.split(' ');
    final List<String> pages = [];
    final maxWidth = screenSize.width - 40; // Margen horizontal
    final maxHeight = screenSize.height; // Usamos todo el alto de la pantalla

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    StringBuffer currentPage = StringBuffer();
    double currentHeight = 0;

    for (final word in words) {
      final testPage =
          currentPage.toString() + (currentPage.isEmpty ? '' : ' ') + word;

      // Configurar el TextPainter con el texto de prueba
      textPainter.text = TextSpan(text: testPage, style: textStyle);
      textPainter.layout(maxWidth: maxWidth);

      // Altura del texto actual
      final lineHeight = textPainter.height;

      // Verificar si el texto cabe en la página actual
      if (currentHeight + lineHeight - 300 > maxHeight) {
        // Guardamos la página actual y empezamos una nueva
        pages.add(currentPage.toString());
        currentPage = StringBuffer(word); // Inicia con la palabra que no cupo
      } else {
        currentPage.write(' $word');
      }
      currentHeight = lineHeight;
    }

    // Agregar cualquier texto restante como la última página
    if (currentPage.isNotEmpty) {
      pages.add(currentPage.toString());
    }

    return pages;
  }

  Future<void> _translateAndPaginate(String content, String language) async {
    setState(() => isLoading = true);

    Navigator.pop(context);

    try {
      // Llama al método de traducción del provider
      await ref
          .read(pageContentProvider.notifier)
          .translateContent(content, language);

      // Escucha el estado traducido y repagina
      final translatedContent = ref.read(pageContentProvider);
      final screenSize = MediaQuery.of(context).size;
      final textStyle = TextStyle(
        fontSize: 17,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        height: 1.75,
      );
      pages = paginateContent(translatedContent, textStyle, screenSize);
    } catch (e) {
      print("Error al traducir el contenido: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showLanguageSelector(String content) {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selecciona un idioma',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.primary),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Español'),
                onTap: () => _translateAndPaginate(content, 'es'),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Inglés'),
                onTap: () => _translateAndPaginate(content, 'en'),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Portugués'),
                onTap: () => _translateAndPaginate(content, 'pt'),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Italiano'),
                onTap: () => _translateAndPaginate(content, 'it'),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Francés'),
                onTap: () => _translateAndPaginate(content, 'fr'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el estado del provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pageContentProvider.notifier).reset();
    });
    _loadChapters();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapters = ref.watch(chapterProvider);
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkmode
        ? const Color(0xFF121212) // Negro tenue (muy oscuro)
        : const Color(0xFFF5E1B2);
    // Estilo del texto
    final textStyle = TextStyle(
      fontSize: 17,
      color: isDarkmode ? Colors.white : Colors.black,
      height: 1.75,
    );

    return Scaffold(
      body: isLoading
          ? Center(
              child: SpinKitFadingCube(
                color: colors.primary,
                size: 50.0,
              ),
            )
          : chapters.isEmpty
              ? MessageEmptyChapter()
              : SafeArea(
                  child: Builder(
                    builder: (context) {
                      if (pages.isEmpty) {
                        final screenSize = MediaQuery.of(context).size;
                        pages = paginateContent(
                          chapters[widget.chapterIndex].content,
                          textStyle,
                          screenSize,
                        );
                      }

                      return PageFlipWidget(
                        key: _controller,
                        backgroundColor: backgroundColor,
                        initialIndex: 0,
                        lastPage: ChaptersViewStoryWithPage(
                          pageContent:
                              'Esperamos que la hayas disfrutado. Para continuar al siguiente capítulo tienes que estar cerca.',
                          textStyle: textStyle,
                          titleChapter: chapters[widget.chapterIndex].title,
                          isEndOfStory:
                              chapters.length - 1 == widget.chapterIndex,
                          isCurrentChapter: widget.chapterIndex,
                          chapterId: chapters[widget.chapterIndex].id,
                          // es mas 1 porque necestiamos saber la posicion del capitulo siguiente
                          latitude: chapters[widget.chapterIndex +
                                  (widget.chapterIndex == chapters.length - 1
                                      ? 0
                                      : 1)]
                              .latitude,
                          longitude: chapters[widget.chapterIndex +
                                  (widget.chapterIndex == chapters.length - 1
                                      ? 0
                                      : 1)]
                              .longitude,
                          randomNumber: initRandomNumber(),
                          currentChapter: widget.chapterIndex + 2,
                          storyId: widget.storyId,
                          imageUrl: chapters[widget.chapterIndex].image ??
                              "sin-imagen",
                        ),
                        children: pages.map((pageContent) {
                          return ChaptersViewStoryWithPage(
                            pageContent: pageContent,
                            textStyle: TextStyle(
                              fontSize:
                                  pages.indexOf(pageContent) == 0 ? 15.5 : 17,
                              color: isDarkmode ? Colors.white : Colors.black,
                              height: 1.75,
                              // pages.indexOf(pageContent) == 0 ? 1.5 : 1.75,
                            ),
                            // si es la primera pagina
                            isFirstPage: pages.indexOf(pageContent) == 0,
                            chapterId: chapters[widget.chapterIndex].id,
                            chapterIndex: widget.chapterIndex,
                            titleChapter: chapters[widget.chapterIndex].title,
                            // es mas 1 porque necestiamos saber la posicion del capitulo siguiente
                            latitude: chapters[widget.chapterIndex +
                                    (widget.chapterIndex == chapters.length - 1
                                        ? 0
                                        : 1)]
                                .latitude,
                            longitude: chapters[widget.chapterIndex +
                                    (widget.chapterIndex == chapters.length - 1
                                        ? 0
                                        : 1)]
                                .longitude,
                            currentChapter: widget.chapterIndex + 2,
                            storyId: widget.storyId,
                            imageUrl: chapters[widget.chapterIndex].image ??
                                "sin-imagen",
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final chapterContent = chapters[widget.chapterIndex].content;
          _showLanguageSelector(chapterContent);
        },
        backgroundColor: isDarkmode
            ? Colors.black.withOpacity(0.6)
            : Colors.white.withOpacity(0.6),
        child: const Icon(Icons.translate),
      ),
    );
  }
}

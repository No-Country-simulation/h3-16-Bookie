import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:bookie/presentation/views/chapter/view/chapters_view_story_page.dart';
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

  Future<void> _loadChapters() async {
    try {
      // Obtener los capítulos usando el provider
      await ref.read(chapterProvider.notifier).getChapters(widget.storyId);
    } catch (e) {
      // Manejo de errores
      print("Error al cargar los capítulos: $e");
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
      // TODO REVISAR EL -350 PORQUE NO ME OCUPABA TODA LA ALTURA DEL DISPOSITIVO REVISAR EN OTROS DISPOSITIVOS
      if (currentHeight + lineHeight - 350 > maxHeight) {
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

  @override
  void initState() {
    super.initState();
    // Cargar los capítulos de la historia
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
        : const Color(0xFFFFF8DC); // Amarillo claro tipo papel (Cornsilk)

    // Estilo del texto
    final textStyle = TextStyle(
      fontSize: 18,
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
              ? Center(child: Text("No hay capítulos disponibles"))
              : SafeArea(
                  child: Builder(
                    builder: (context) {
                      final screenSize = MediaQuery.of(context).size;
                      List<String> pages = [];

                      pages.addAll(paginateContent(
                        chapters[widget.chapterIndex].content,
                        textStyle,
                        screenSize,
                      ));

                      return PageFlipWidget(
                        key: _controller,
                        backgroundColor: backgroundColor,
                        initialIndex: 0,
                        lastPage: ChaptersViewStoryWithPage(
                          pageContent:
                              'Esperamos que la hayas disfrutado. Para continuar al siguiente capítulo tienes que estar cerca.',
                          textStyle: textStyle,
                          isEndOfStory:
                              chapters.length - 1 == widget.chapterIndex,
                          isCurrentChapter: widget.chapterIndex,
                          // es mas 1 porque necestiamos saber la posicion del capitulo siguiente
                          latitude: chapters[widget.chapterIndex + 1].latitude,
                          longitude:
                              chapters[widget.chapterIndex + 1].longitude,
                        ),
                        children: pages.map((pageContent) {
                          return ChaptersViewStoryWithPage(
                            pageContent: pageContent,
                            textStyle: TextStyle(
                              fontSize:
                                  pages.indexOf(pageContent) == 0 ? 16 : 18,
                              color: isDarkmode ? Colors.white : Colors.black,
                              height: 1.75,
                              // pages.indexOf(pageContent) == 0 ? 1.5 : 1.75,
                            ),
                            // si es la primera pagina
                            isFirstPage: pages.indexOf(pageContent) == 0,
                            chapterIndex: widget.chapterIndex,
                            titleChapter: chapters[widget.chapterIndex].title,
                            // es mas 1 porque necestiamos saber la posicion del capitulo siguiente
                            latitude:
                                chapters[widget.chapterIndex + 1].latitude,
                            longitude:
                                chapters[widget.chapterIndex + 1].longitude,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
    );
  }
}

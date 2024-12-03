import 'package:animate_do/animate_do.dart';
import 'package:bookie/config/constants/general.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ChapterSuccessCompleteChapterView extends StatefulWidget {
  static const String name = 'chapter-success-chapter-view';
  final String pageContent;
  final int isCurrentChapter;
  final double latitude;
  final double longitude;
  final int randomNumber;
  final int currentChapter;
  final String title;

  const ChapterSuccessCompleteChapterView(
      {super.key,
      required this.pageContent,
      required this.isCurrentChapter,
      required this.latitude,
      required this.longitude,
      required this.randomNumber,
      required this.currentChapter,
      required this.title});

  @override
  State<ChapterSuccessCompleteChapterView> createState() =>
      _ChapterSuccessCompleteChapterViewState();
}

class _ChapterSuccessCompleteChapterViewState
    extends State<ChapterSuccessCompleteChapterView> {
  late Future<bool> isUnlockedFuture;

  Future<bool> isChapterUnlocked() async {
    try {
      final userPosition = await determinePosition();
      final double radius = GeneralConstants.radius;
      final isUnlocked = isWithinRadius(
        userPosition,
        widget.latitude,
        widget.longitude,
        radius,
      );

      return isUnlocked;
    } catch (e) {
      print('Error al determinar la posición: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    isUnlockedFuture = isChapterUnlocked();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshLocation() {
    setState(() {
      isUnlockedFuture =
          isChapterUnlocked(); // Actualiza el estado para recalcular
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            GestureDetector(
              child: BounceInDown(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                      'assets/lottie/success_complete_chapter_${widget.randomNumber}.json'),
                ),
              ),
            ),
            const SizedBox(height: 50),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: FadeInDown(
                  key: const ValueKey(1),
                  child: Text(
                    "Fin del capítulo 📖",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                      shadows: const [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            FadeInDown(
              delay: const Duration(milliseconds: 500),
              child: Text(
                widget.pageContent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  // color: colors.primary,
                  // shadows: const [
                  //   Shadow(
                  //     blurRadius: 10,
                  //     color: Colors.black45,
                  //     offset: Offset(2, 2),
                  //   ),
                  // ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                // Botón para ir al capítulo anterior (desbloqueado)
                if (widget.isCurrentChapter > 0)
                  ElevatedButton.icon(
                    onPressed: () {
                      // Acción para ir al capítulo anterior
                      context.push(
                          '/chapters/view/128/${widget.isCurrentChapter - 1}');
                    },
                    icon: const Icon(Icons.lock_open,
                        color: Colors.green), // Ícono desbloqueado
                    label: Text('Ir al capítulo ${widget.isCurrentChapter}'),
                  ),
                const SizedBox(height: 10),

                // Botón para ir al siguiente capítulo (bloqueado)
                // TODO: AQUI FALTA LA LOGICA CUANDO EL CAPITULO ES DESBLOQUEADO CUANDO EL LECTOR YA LO DESBLOQUEO ANTES QUE SON DE HISTORIAS LEIDAS.
                FutureBuilder<bool>(
                  future: isUnlockedFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: SizedBox(
                            height: 30.0,
                            width: 30.0,
                            child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error al obtener la ubicación.',
                        style: TextStyle(color: Colors.red),
                      );
                    } else {
                      final isUnlocked = snapshot.data ?? false;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Acción para ir al siguiente capítulo
                              isUnlocked
                                  ? context.push(
                                      '/chapters/view/128/${widget.isCurrentChapter + 1}')
                                  : context.push(
                                      '/chapters/view/128/${widget.isCurrentChapter + 1}/map',
                                      extra: {
                                        'latitude': widget.latitude,
                                        'longitude': widget.longitude,
                                        'currentChapter': widget.currentChapter,
                                        'title': widget.title
                                      },
                                    );
                            },
                            icon: Icon(
                                isUnlocked ? Icons.lock_open : Icons.lock,
                                color: isUnlocked
                                    ? Colors.green
                                    : Colors.red), // Ícono bloqueado
                            label: Text(
                                '${isUnlocked ? "Ir al capítulo" : "Capítulo"} ${widget.isCurrentChapter + 2}${isUnlocked ? '' : ' (ir al mapa)'}'),
                          ),
                          IconButton(
                              onPressed: refreshLocation,
                              icon: Icon(
                                Icons.refresh,
                                color: colors.primary,
                              )),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 10),

                // Botón para ir a Home con ícono de Home al inicio
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción para ir al Home
                    context.go('/chapter/success/128');
                  },
                  icon:
                      Icon(Icons.home, color: colors.primary), // Ícono de Home
                  label: const Text('Ir a Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

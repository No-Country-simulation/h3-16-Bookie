import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bookie/presentation/providers/translater_chapter.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ChapterSuccess extends ConsumerStatefulWidget {
  static const String name = 'chapter-success';
  final int storyId;
  final int chapterIndex;

  const ChapterSuccess(
      {super.key, required this.storyId, required this.chapterIndex});

  @override
  ConsumerState<ChapterSuccess> createState() => _ChapterSuccessState();
}

class _ChapterSuccessState extends ConsumerState<ChapterSuccess> {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    // Dispara el confetti automáticamente al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerConfetti() {
    setState(() {
      _confettiController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado
          const AnimatedBackground(),
          // Confetti explosivo
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive, // Solo explosión
              emissionFrequency: 0.05,
              numberOfParticles: 10,
              gravity: 0.2,
              colors: [
                Colors.yellow,
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange,
              ],
            ),
          ),
          // Contenido principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animación épica
                GestureDetector(
                  onTap: () => _triggerConfetti(),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset('assets/lottie/success.json'),
                  ),
                ),
                const SizedBox(height: 20),
                // Texto animado 3D
                SizedBox(
                  height: 50,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ScaleAnimatedText(
                        '¡Capítulo Creado!',
                        textStyle: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black45,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        scalingFactor: 0.8, // Escala más suave
                        duration: const Duration(milliseconds: 1500),
                      ),
                    ],
                    repeatForever: true,
                    pause: const Duration(milliseconds: 300),
                    onTap: () => _triggerConfetti(),
                  ),
                ),
                const SizedBox(height: 40),
                // Botones mágicos

                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // limpiar la vista del capitulo
                        ref.read(pageContentProvider.notifier).reset();

                        // Acción para vista previa
                        context.push(
                            '/chapters/view/${widget.storyId}/${widget.chapterIndex}');
                      },
                      child: const Text('Vista Previa'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Acción para añadir capítulo
                        context.pop();
                      },
                      child: const Text('Añadir Otro Capítulo'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Acción para ir al home
                        context.push('/home/2');
                      },
                      child: const Text('Ir a mis historias'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Fondo animado
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.yellow,
                Colors.amber.withOpacity(_controller.value),
                Colors.black,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Botones mágicos
// Widget ButtonColumn(BuildContext context,
//     {required int storyId, required int chapterIndex, Ref ref}) {
//   return Column(
//     children: [
//       ElevatedButton(
//         onPressed: () {
//           // limpiar la vista del capitulo
//           ref.read(pageContentProvider.notifier).reset();

//           // Acción para vista previa
//           context.push('/chapters/view/$storyId/$chapterIndex');
//         },
//         child: const Text('Vista Previa'),
//       ),
//       const SizedBox(height: 10),
//       ElevatedButton(
//         onPressed: () {
//           // Acción para añadir capítulo
//           context.pop();
//         },
//         child: const Text('Añadir Otro Capítulo'),
//       ),
//       const SizedBox(height: 10),
//       ElevatedButton(
//         onPressed: () {
//           // Acción para ir al home
//           context.push('/home/2');
//         },
//         child: const Text('Ir a mis historias'),
//       ),
//     ],
//   );
// }

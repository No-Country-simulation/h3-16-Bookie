import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ChapterSuccessCompleteStoryView extends StatefulWidget {
  static const String name = 'chapter-success-story-view';
  final String pageContent;

  const ChapterSuccessCompleteStoryView({super.key, required this.pageContent});

  @override
  State<ChapterSuccessCompleteStoryView> createState() =>
      _ChapterSuccessCompleteStoryViewState();
}

class _ChapterSuccessCompleteStoryViewState
    extends State<ChapterSuccessCompleteStoryView> {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
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
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
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
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => _triggerConfetti(),
                  child: BounceInDown(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset(
                          'assets/lottie/success_complete_story.json'),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
                    child: FadeInDown(
                      key: const ValueKey(1),
                      child: Text(
                        "Fin de la historia 📖",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                      ),
                    )),
                const SizedBox(height: 20),
                FadeInDown(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    "¡Felicidades! 🎉 Has llegado al final de esta historia. Vuelve al inicio y descubre más aventuras esperando por ti.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                ),
                const SizedBox(height: 80),
                ButtonColumn(context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Botones mágicos
Widget ButtonColumn(BuildContext context) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: () {
          context.push('/home/0');
        },
        child: const Text('Ir a Home'),
      ),
    ],
  );
}

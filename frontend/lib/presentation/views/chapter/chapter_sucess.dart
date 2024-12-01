import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ChapterSuccess extends StatelessWidget {
  static const String name = 'chapter-success';

  const ChapterSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado
          AnimatedBackground(),
          // Contenido principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animación épica
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                      'assets/lottie/success.json'), // Ruta al archivo Lottie
                ),
                SizedBox(height: 20),
                // Título legendario
                Text(
                  '¡Capítulo Creado!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                // Botones mágicos
                ButtonColumn(context),
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
Widget ButtonColumn(BuildContext context) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: () {
          // Acción para vista previa
        },
        child: Text('Vista Previa'),
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          // Acción para añadir capítulo
          context.pop();
        },
        child: Text('Añadir Otro Capítulo'),
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          // Acción para ir al home
          context.go('/home/0');
        },
        child: Text('Ir a Home'),
      ),
    ],
  );
}

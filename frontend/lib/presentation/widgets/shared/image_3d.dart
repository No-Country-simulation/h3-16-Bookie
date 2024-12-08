import 'dart:math';
import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:flutter/material.dart';

class My3DImage extends StatefulWidget {
  final String imageUrl;
  final int storyId;

  const My3DImage({
    super.key,
    required this.imageUrl,
    required this.storyId,
  });

  @override
  State<My3DImage> createState() => _My3DImageState();
}

class _My3DImageState extends State<My3DImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward(); // Iniciar animación automáticamente

    // Definir la animación de rotación
    _rotationAnimation = Tween<double>(begin: pi / 2, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    final imageMod = getImageUrl(isDarkmode, widget.imageUrl);

    return Hero(
      tag: 'hero-image-${widget.storyId}',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Fondo con sombra que simula el interior del libro
              Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  boxShadow: [
                    BoxShadow(
                      color: !isDarkmode
                          ? Colors.black26
                          : Colors.white10, // Sombra de fondo
                      blurRadius: 20,
                      offset: const Offset(2.5, 2.5), // Sombra proyectada
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              // Tapa del libro con animación 3D
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Efecto de perspectiva
                  ..rotateY(_rotationAnimation.value),
                alignment: Alignment.centerLeft, // Anclar al borde izquierdo
                child: child,
              ),
            ],
          );
        },
        child: Image.network(
          imageMod,
          width: 200, // Dimensiones tipo libro
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

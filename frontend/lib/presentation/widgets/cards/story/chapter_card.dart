import 'package:flutter/material.dart';

class ChapterCard extends StatelessWidget {
  final int index;
  final String title;
  final String imageUrl;
  final bool isUnlocked;

  const ChapterCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.index,
    required this.isUnlocked, // Indica si el capítulo está desbloqueado
  });

  @override
  Widget build(BuildContext context) {
    // Color de fondo oscuro y ajustes para el diseño
    final lockIcon = isUnlocked ? Icons.lock_open : Icons.lock;
    final iconColor = isUnlocked ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Esquinas redondeadas
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Espacio entre los elementos
          children: [
            // Parte izquierda: Imagen con mayor peso y altura
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 80, // Aumentamos el ancho de la imagen
                height: 80, // Aumentamos la altura de la imagen
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 4.0), // Espacio entre el imagen y el texto

            // Parte derecha: Información del capítulo
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Capítulo número y estado (bloqueado/desbloqueado)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Capítulo ${index + 1}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          lockIcon,
                          color:
                              iconColor, // Cambiamos el color según el estado
                          size: 24.0,
                        ),
                      ],
                    ),

                    // Título del capítulo
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),

                    // Distancia
                    const SizedBox(height: 4.0),
                    const Text(
                      "A 10 m",
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

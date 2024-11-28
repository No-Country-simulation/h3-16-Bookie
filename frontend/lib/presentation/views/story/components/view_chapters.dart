import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/presentation/widgets/cards/story/chapter_card.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class StoryChapters extends StatelessWidget {
  const StoryChapters({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Función para obtener capítulos desbloqueados basados en la ubicación
    bool isWithinRadius(Position userPosition, double targetLat,
        double targetLon, double radius) {
      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        targetLat,
        targetLon,
      );

      return distance <= radius;
    }

    Future<List<Map<String, dynamic>>> getUnlockedChapters() async {
      try {
        final userPosition = await determinePosition();
        const double radius = 15; // Radio de 20 metros
        final chaptersMod = chapters.map((chapter) {
          final isUnlocked = isWithinRadius(
            userPosition,
            chapter['latitude'],
            chapter['longitude'],
            radius,
          );

          return {
            ...chapter,
            'isUnlocked': isUnlocked,
          };
        }).toList();

        return chaptersMod;
      } catch (e) {
        print('Error al determinar la posición: $e');
        return [];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Capítulos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Para desbloquear los capítulos, debes estar cerca.",
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: getUnlockedChapters(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text('Error al cargar los capítulos'),
              );
            }

            final chapters = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                bool isUnlocked = index == 0 ||
                    index ==
                        1; // El primer capítulo está desbloqueado, el segundo también.

                return ChapterCard(
                  isUnlocked: isUnlocked,
                  index: index,
                  title: "title chapter ${index + 1}",
                  imageUrl: "https://picsum.photos/id/${index + 1}/200/300",
                );
                // ListTile(
                //   title: Text(chapter['title']),
                //   subtitle: chapter['isUnlocked']
                //       ? const Text('Desbloqueado')
                //       : const Text(
                //           'Bloqueado - Acércate al lugar para desbloquear'),
                //   trailing: Icon(
                //     chapter['isUnlocked'] ? Icons.lock_open : Icons.lock,
                //     color: chapter['isUnlocked'] ? Colors.green : Colors.red,
                //   ),
                // );
              },
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

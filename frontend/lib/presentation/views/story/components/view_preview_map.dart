import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryPreviewMaps extends StatelessWidget {
  final double latitude;
  final double longitude;
  final int storyId;
  final List<ChapterPartial> chapters;

  const StoryPreviewMaps(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.chapters,
      required this.storyId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    final markersImageView = chapters
        .asMap()
        .map((index, chapter) {
          // Asignar un número como etiqueta para cada marcador
          String label =
              (index + 1).toString(); // Etiqueta como "1", "2", "3", ...

          return MapEntry(index,
              'label:$label|${chapter.latitude},${chapter.longitude}' // Usamos solo la etiqueta sin ícono
              );
        })
        .values
        .join('&markers=');

    Future<void> openGoogleMaps() async {
      try {
        // Obtener la ubicación actual del usuario
        final position = await determinePosition();

        final currentLocation = "${position.latitude},${position.longitude}";

        // Crear la URL de Google Maps
        final googleMapsUrl =
            "https://www.google.com/maps/dir/?api=1&origin=$currentLocation&destination=$latitude,$longitude&travelmode=driving";

        // Intentar abrir Google Maps
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl),
              mode: LaunchMode.externalApplication);
        } else {
          throw 'No se pudo abrir Google Maps';
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al obtener la ubicación')),
          );
        }
      }
    }

    return Column(
      children: [
        // Mapa
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Ver recorrido',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.primary)),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // Navegar a la pantalla de mapa
                context.push(
                  '/chapters/view/$storyId/0/map',
                  extra: {
                    'latitude': latitude,
                    'longitude': longitude,
                    'currentChapter': 0,
                    'storyId': storyId
                  },
                );
              },
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=$markersImageView'
                    '${isDarkmode ? '&style=feature:all|element:geometry|color:0x212121' // Fondo oscuro
                            '&style=feature:all|element:labels.text.stroke|color:0x212121' // Eliminar bordes
                            '&style=feature:all|element:labels.text.fill|color:0xffffff' // Texto claro
                            '&style=feature:poi|element:geometry|color:0x37474f' // POI en gris oscuro
                            '&style=feature:poi|element:labels.icon|visibility:on|color:0x757575' // Íconos POI opacos
                            '&style=feature:road|element:geometry|color:0x4e4e4e' // Carreteras más claras
                            '&style=feature:road|element:geometry.stroke|color:0x616161' // Bordes de carretera claros
                            '&style=feature:road|element:labels.text.fill|color:0xeaeaea' // Texto claro en carreteras
                            '&style=feature:transit|element:geometry|color:0x2f3948' // Transporte oscuro
                            '&style=feature:transit|element:labels.icon|visibility:on|color:0x616161' // Íconos de transporte opacos
                            '&style=feature:administrative|element:labels.icon|visibility:on|color:0x616161' // Íconos administrativos opacos
                            '&style=feature:landscape.natural|element:labels.icon|visibility:on|color:0x616161' // Íconos de paisajes naturales opacos
                            '&style=feature:business|element:labels.icon|visibility:on|color:0x616161' // Íconos de negocios opacos
                            '&style=feature:water|element:geometry|color:0x000000' // Agua negra
                        : ""}'
                    '&key=${Environment.theGoogleMapsApiKey}',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SpinKitFadingCircle(
                        color: colors.primary,
                        size: 30.0,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                          child: Text('Error al cargar el mapa'));
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            ElevatedButton.icon(
              onPressed: openGoogleMaps,
              icon: Icon(
                Icons.map,
                size: 18, // Tamaño reducido del icono
                color: colors.secondary,
              ),
              label: Text(
                'Ir a Google Maps',
                style: TextStyle(fontSize: 14, color: colors.secondary),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12), // Padding reducido
                elevation: 2, // Elevación más baja
              ),
            ),
          ],
        ),
      ],
    );
  }
}

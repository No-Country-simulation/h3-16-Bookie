import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryPreviewMaps extends StatelessWidget {
  final double latitude;
  final double longitude;
  final int storyId;

  const StoryPreviewMaps(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.storyId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
          print('Error al obtener la ubicación: $e');
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
                    'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=600x300&maptype=roadmap&markers=icon:https://res.cloudinary.com/dlixnwuhi/image/upload/v1733415545/wcqq4dl23cpcx6cslcgr.png%7Clabel:S%7C$latitude,$longitude&key=${Environment.theGoogleMapsApiKey}',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
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

import 'package:bookie/shared/data/histories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class HistoryScreen extends StatelessWidget {
  final String historyId; // Recibimos el id desde la ruta
  static const String name = 'history';

  const HistoryScreen({super.key, required this.historyId});

  @override
  Widget build(BuildContext context) {
    final history = [...readStories, ...unreadStories].firstWhere(
      (history) => history['id'] == historyId,
    );

    final colors = Theme.of(context).colorScheme;

    // Configuración de ubicación
    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Actualiza cada 100 metros
    );

    // Función para abrir Google Maps con un recorrido desde la ubicación actual hasta el destino
    Future<void> openGoogleMaps() async {
      try {
        // Obtener la ubicación actual del usuario
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        final currentLocation = "${position.latitude},${position.longitude}";
        final googleMapsUrl =
            "https://www.google.com/maps/dir/?api=1&origin=$currentLocation&destination=${history['latitud']},${history['longitud']}&travelmode=driving";

        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl),
              mode: LaunchMode.externalApplication);
        } else {
          throw 'No se pudo abrir Google Maps';
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al obtener la ubicación: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('History $historyId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop(); // Retroceder si hay una pantalla en la pila
            } else {
              context.go('/home/0'); // Redirigir a la pantalla de inicio
            }
          },
        ),
      ),
      body: ListView(
        children: [
          // Hero Image (25% de la pantalla)
          Hero(
            tag: 'hero-image-$historyId',
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(history['imageUrl'] as String),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black54, // Fondo oscuro para visibilidad
                child: Center(
                  child: Text(
                    history['title'] as String, // Título dinámico
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),

          // Sinopsis
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sinopsis',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Esta es la sinopsis de la historia que tiene una narrativa emocionante sobre el viaje que vas a realizar. Prepárate para una gran aventura.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          // Duración del viaje y botón de Google Maps
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.grey),
                        SizedBox(width: 4.0),
                        Text('Duración del viaje: 30 min'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.add_road, color: Colors.grey),
                        SizedBox(width: 4.0),
                        Text('10 km de recorrido'),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: openGoogleMaps,
                  child: const Text('Ir a Google Maps'),
                ),
              ],
            ),
          ),

          // Mapa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mapa',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // context.go('/home/5');
                    context.go('/home/1');
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/logo.webp'), // Cambiar por imagen real
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Ver Mapa',
                        style: TextStyle(
                          backgroundColor: Colors.black45,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lugares cercanos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lugares',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const ListTile(
                  title: Text('Lugar 1'),
                  subtitle: Text(
                      'Descripción breve del lugar. Lorem ipsum dolor sit amet.'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: openGoogleMaps,
        tooltip: 'Start',
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        child: const Text('Start'),
      ),
    );
  }
}

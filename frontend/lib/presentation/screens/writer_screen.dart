import 'package:bookie/shared/data/writers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WriterProfileScreen extends StatelessWidget {
  final String writerId;
  static const String name = 'writer-profile';

  const WriterProfileScreen({super.key, required this.writerId});

  @override
  Widget build(BuildContext context) {
    // Buscar escritor por id
    final writer = writers.firstWhere((w) => w['id'] == writerId);
    final writerName = writer['name'];
    final writerImageUrl = writer['imageUrl'];
    final bannerImageUrl =
        "https://picsum.photos/id/$writerId/200/300"; // Banner simulado
    final bio = writer['bio'];
    final stories = writer['stories'];

    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Acción para volver al inicio
            context.go('/home/0');
          },
        ),
        title: const Text('Escritor'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado con banner e imagen del escritor
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Imagen de fondo (banner)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(bannerImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Imagen del escritor
                Positioned(
                  bottom: -50,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        isDarkmode ? Colors.grey[800] : Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(writerImageUrl),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60), // Espacio para la imagen circular
            // Nombre del escritor
            Center(
              child: Text(
                writerName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Biografía breve
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                bio,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkmode ? Colors.grey[400] : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Botón de acción
            // Center(
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       // Acción para seguir al escritor
            //     },
            //     icon: const Icon(Icons.person_add),
            //     label: const Text('Seguir al escritor'),
            //     style: ElevatedButton.styleFrom(
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            // Historias del escritor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Historias',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkmode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Lista de historias
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        story['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(story['title']),
                    subtitle: Text(
                        '${story['chapters']} capítulos | Ubicación: ${story['location']}'),
                    onTap: () {
                      // Acción para navegar a la historia
                      context.go('/history/${story['id']}');
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

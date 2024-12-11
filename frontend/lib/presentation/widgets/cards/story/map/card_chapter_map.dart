import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardStoryMap extends StatelessWidget {
  // final String title;
  final int index;

  const CardStoryMap({
    super.key,
    // required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        // Acción al pulsar el card
        context.push('/story/1');
      },
      splashColor: colors.primary.withAlpha(30),
      highlightColor: colors.primary.withAlpha(50),
      child: Card(
        color: isDarkmode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
            width: double.infinity, // Ancho del card
            height: 160, // Alto del card
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Imagen que ocupa 1/4 del card
                      Container(
                        width: 75, // 1/4 del tamaño total
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                              // URL de la imagen (puedes reemplazar con la base de datos en el futuro)
                              'https://picsum.photos/seed/chapter${index + 1}/100',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // ListTile para el título y subtítulo
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "title story $index",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary),
                              ),
                              Text(
                                'Capítulo $index',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Icono de bloqueo o desbloqueo en la esquina superior derecha
                ],
              ),
            )),
      ),
    );
  }
}

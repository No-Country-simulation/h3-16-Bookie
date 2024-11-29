import 'package:flutter/material.dart';

class CreateChapterForm extends StatelessWidget {
  static const String name = 'create-chapter';

  const CreateChapterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Capítulo"),
        actions: [
          TextButton(
            onPressed: () {
              // Lógica de guardado del capítulo
            },
            child: Text(
              "Guardar",
              style: TextStyle(
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de imagen del capítulo
            GestureDetector(
              onTap: () {
                // Lógica para seleccionar una imagen
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: colors.onSurface.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                  color: colors.surface,
                ),
                child: Center(
                  child: const Text("Seleccionar imagen del capítulo"),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input de título del capítulo
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Título del Capítulo",
              ),
            ),
            const SizedBox(height: 16),

            // Área de texto del capítulo
            TextFormField(
              maxLines: null, // Permite texto con múltiples líneas
              decoration: const InputDecoration(
                labelText: "Escribir el capítulo",
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            // Barra de herramientas de edición
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Deshacer
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.undo),
                  tooltip: "Deshacer",
                ),
                // Rehacer
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.redo),
                  tooltip: "Rehacer",
                ),
                // Alineación
                PopupMenuButton<String>(
                  onSelected: (value) {},
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'left',
                      child: Text('Alinear a la izquierda'),
                    ),
                    const PopupMenuItem(
                      value: 'center',
                      child: Text('Centrar'),
                    ),
                    const PopupMenuItem(
                      value: 'right',
                      child: Text('Alinear a la derecha'),
                    ),
                  ],
                  icon: const Icon(Icons.format_align_left),
                  tooltip: "Alineación",
                ),
                // Cambiar idioma
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.translate),
                  tooltip: "Cambiar idioma",
                ),
                // Marcar ubicación
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on),
                  tooltip: "Marcar posición",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonHome extends StatelessWidget {
  const ButtonHome({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton.icon(
      onPressed: () {
        // Acción del botón
        context.push('/home/0');
      },
      icon: Icon(
        Icons.home, // Cambia el icono según sea necesario
        color: isDarkmode ? Colors.white : Colors.black,
        size: 20, // Tamaño del ícono
      ),
      label: Text(
        'Ir al home', // Título del botón
        style: TextStyle(
          color: isDarkmode ? Colors.white : Colors.black,
          fontSize: 14, // Tamaño de la fuente
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: isDarkmode ? colors.primary : Colors.white,
      ),
    );
  }
}
